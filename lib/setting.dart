import 'package:flutter/material.dart';
import 'package:liaou/consts.dart';
import 'package:liaou/blmain.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);
  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting> {
  final BlMain blMain = BlMain();
  _reScanSetting() {
    // var subscription = flutterBlue.scanResults.listen((scanResult) {
    //   // do something with scan result
    //   device = scanResult.device;
    //   print('${device.name} found! rssi: ${scanResult.rssi}');
    // });
  }
  //build bluetooth list view
  ListView _buildBluetoothListView() {
    List<Container> lstContainer = [];
    for (BluetoothDevice d in blMain.lstBluetoothDevice) {
      lstContainer.add(
        Container(
          height: Consts.DEVICE_LIST_ITEM_HEIGHT,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(d.name == '' ? Consts.DEVICE_UNKNOWN : d.name),
                    Text(d.id.toString()),
                  ],
                ),
              ),
              TextButton(
                child: Text(Consts.CONNECT),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  onSurface: Colors.grey,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(Consts.EDGE_INSERT_NUM),
      children: <Widget>[
        ...lstContainer,
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Consts.SETTING_PAGE),
        ),
        body: _buildBluetoothListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: _reScanSetting,
          tooltip: Consts.RESCAN,
          child: Icon(Icons.refresh_rounded),
        ),
      );
}
