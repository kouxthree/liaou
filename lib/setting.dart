import 'package:flutter/material.dart';
import 'package:liaou/consts.dart';
import 'package:liaou/blmain.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'dart:async';
import 'package:flutter/services.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);
  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting> {
  String _msg = "";
  //static const platform = const MethodChannel('com.liaou.bl');
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  //final BlMain blMain = BlMain();
  List<ScanResult> _lstScanResult = [];

  Future<void> _openBluetooth() async {
    String msg = "";
    try {
      msg = await platform.invokeMethod('openBluetooth');
    } on PlatformException catch (e) {
      msg = msg.toString() + e.message.toString();
    }
    setState(() => _msg = msg);
  }

  Future<void> _getBluetooth() async {
    String msg = "";
    try {
      msg = await platform.invokeMethod('getBluetooth');
    } on PlatformException catch (e) {
      msg = msg.toString() + e.message.toString();
    }
    setState(() => _msg = msg);
  }

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    //_openBluetooth();
    //_reScan();
  }

  //rescan bluetooth devices
  Future<void> _reScan() async {
    setState(() async {
      //_lstScanResult = await blMain.reScan();
    });
  }

  //get specific bluetooth device rssi
  _getRssi(ScanResult r) {
    //Navigator.pop(context, true);//go back to main page
    r.rssi;
  }

  //build bluetooth list view
  ListView _buildBluetoothListView() {
    List<Container> lstContainer = [];
    for (ScanResult r in _lstScanResult) {
      lstContainer.add(
        Container(
          height: Consts.DEVICE_LIST_ITEM_HEIGHT,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(r.device.name == ''
                        ? Consts.DEVICE_UNKNOWN
                        : r.device.name),
                    Text(r.device.id.toString()),
                  ],
                ),
              ),
              TextButton(
                child: Text(Consts.GET_RSSI_SAMPLES),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  onSurface: Colors.grey,
                ),
                onPressed: () {
                  _getRssi(r);
                },
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

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       appBar: AppBar(
  //         title: Text(Consts.SETTING_PAGE),
  //       ),
  //       body:_buildBluetoothListView(),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () => {}, //_reScan,
  //         tooltip: Consts.RESCAN,
  //         child: Icon(Icons.refresh_rounded),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }


}
