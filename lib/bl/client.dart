import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../consts.dart';

class Client extends StatefulWidget {
  final FlutterBlue fb = FlutterBlue.instance;
  final List<BluetoothDevice> lstDev = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _ClientState createState() => _ClientState();

  _startScan() async {
    if (fb.state == BluetoothState.unavailable) {
      return;
    }
    if (!(await fb.isOn)) {
      await Future.delayed(Duration(seconds: 3));
    }
    if (!(await fb.isOn)) {
      return;
    }
    lstDev.clear();
    fb.startScan();
  }
}

class _ClientState extends State<Client> {
  var _connectedDevice;
  var _services;
  final _writeController = TextEditingController();
  // var _searchIcon; //show search or search-off icon

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
  }

  //add devices to list
  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.lstDev.contains(device)) {
      //add known identifier device
      // if(Consts.COM.compareTo(device.id.toString()) == 0) {
      setState(() {
        widget.lstDev.add(device);
      });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  //build main view
  _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  //build device list view
  _buildListViewOfDevices() {
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
                child: Text(
                  'Connect',
                ),
                onPressed: () {
                  _connectButtonTapped(device);
                },
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 10,
            child: FloatingActionButton(
              child: Icon(Icons.search),
              backgroundColor: Colors.blue,
              onPressed: () => _onSearchIconTapped(),
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     StreamBuilder<bool>(
          //       stream: widget.fb.isScanning,
          //       initialData: false,
          //       builder: (c, snapshot) {
          //         if (snapshot.data!) {
          //           return FloatingActionButton(
          //             child: Icon(Icons.stop),
          //             backgroundColor: Colors.blue,
          //             // onPressed: () => _onSearchIconTapped(false),
          //             onPressed: () => widget.fb.stopScan(),
          //           );
          //         } else {
          //           return FloatingActionButton(
          //             child: Icon(Icons.search),
          //             backgroundColor: Colors.grey,
          //             // onPressed: () => _onSearchIconTapped(true),
          //             onPressed: () =>
          //                 widget.fb.startScan(timeout: Duration(seconds: 4)),
          //           );
          //         }
          //       },
          //     ),
          //   ],
          // ),
          Expanded(
            flex: 90,
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  ...containers,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //build connected device list view
  _buildConnectDeviceView() {
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

    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ...containers,
        ],
      ),
    );
  }

  //search icon tapped
  void _onSearchIconTapped() async {
    widget.fb.stopScan();
    widget.lstDev.clear();
    widget._startScan(); //(timeout: Duration(seconds: 4));//turn on searching
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];
    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              child: Text(
                'READ',
              ),
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
              child: Text(
                'WRITE',
              ),
              onPressed: () {
                _writeButtonTapped(characteristic);
              },
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
    try {
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
                  characteristic
                      .write(utf8.encode(_writeController.value.text));
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
