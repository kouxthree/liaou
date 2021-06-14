import 'dart:async';
import 'dart:core';
import 'package:permission_handler/permission_handler.dart';

class Permit {
  Future<bool> requestPermission() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
    if (await Permission.bluetooth.isPermanentlyDenied ||
        await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
    if (await Permission.bluetooth.status.isGranted &&
        await Permission.location.isGranted)
      return true;
    else
      return false;
  }
}
