import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BlMain extends StatefulWidget {
  BlMain({Key? key}) : super(key: key);
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> lstBluetoothDevice = [];

  @override
  _BlMain createState() => _BlMain();
}

class _BlMain extends State<BlMain> {
  //add bluetooth device to list
  _addBluetoothDeviceToList(final BluetoothDevice d) {
    if (!widget.lstBluetoothDevice.contains(d)) {
      setState(() {
        widget.lstBluetoothDevice.add(d);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //add connected bluetooth device
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice d in devices) {
        _addBluetoothDeviceToList(d);
      }
    });
    //add scanned bluetooth device
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addBluetoothDeviceToList(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) => Scaffold();
}
