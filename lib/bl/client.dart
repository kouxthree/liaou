import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Client extends StatefulWidget {
  final FlutterBlue fb = FlutterBlue.instance;
  final List<BluetoothDevice> lstDev = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

   @override
  _ClientState createState() => _ClientState();

   startScan() {
     fb.startScan();
   }
}

class _ClientState extends State<Client> {
  var _connectedDevice;
  var _services;
  final _writeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //add connected devices to list
    widget.fb.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    //added ascanned devices to list
    widget.fb.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.startScan();
  }
  //add devices to list
  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.lstDev.contains(device)) {
      setState(() {
        widget.lstDev.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildView(),
    );
  }

  //build main view
  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }
  //build device list view
  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in widget.lstDev) {
      containers.add(
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              TextButton(
                child: Text('Connect',),
                onPressed: _connectButtonTapped(device),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );;
  }
  //build connected device list view
  ListView _buildConnectDeviceView() {
    List<Container> containers = <Container>[];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = <Widget>[];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }
  List<ButtonTheme> _buildReadWriteNotifyButton(BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];
    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: Text('READ',),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: Text('WRITE',),
              onPressed: _writeButtonTapped(characteristic),
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }
    return buttons;
  }
  //connect button tapped
  _connectButtonTapped(BluetoothDevice device) async {
    widget.fb.stopScan();
    try{
      await device.connect();
    // } catch (e) {
    //   if (e.code != 'already_connected') {
    //     throw e;
    //   }
    } finally {
      _services = await device.discoverServices();
    }
    setState(() {
      _connectedDevice = device;
    });
  }
  _writeButtonTapped(BluetoothCharacteristic characteristic) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Write"),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _writeController,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Send"),
                onPressed: () {
                  characteristic.write(
                      utf8.encode(_writeController.value.text));
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}