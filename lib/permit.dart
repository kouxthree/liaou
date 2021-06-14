import 'dart:async';
import 'dart:core';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class Permit {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Future<bool> _checkDeviceBluetoothIsOn() async {
    return await flutterBlue.isOn;
  }

  Future<bool> _checkDeviceLocationIsOn() async {
    return await Permission.locationWhenInUse.serviceStatus.isEnabled;
  }

  Future<bool> requestPermission() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
    if (await Permission.bluetooth.isPermanentlyDenied ||
        await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
    if (await _checkDeviceBluetoothIsOn() &&
        await _checkDeviceLocationIsOn() &&
        await Permission.bluetooth.status.isGranted &&
        await Permission.location.isGranted)
      return true;
    else
      return false;
  }
}
