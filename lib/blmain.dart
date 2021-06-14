import 'package:flutter_blue/flutter_blue.dart';
import 'package:liaou/consts.dart';

class BlMain {
  final flutterBlue = FlutterBlue.instance;
  final List<ScanResult> lstBluetoothDevice = [];

  //refresh scanned bluetooth devices list
  refreshDeviceList() {
    // lstBluetoothDevice.clear();
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: Consts.SCAN_TIMEOUT));
    //add scanned devices to list
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        final knownDeviceIndex =
            lstBluetoothDevice.indexWhere((d) => d.device.id == r.device.id);
        if (knownDeviceIndex >= 0) {
          lstBluetoothDevice[knownDeviceIndex] = r;
        } else {
          lstBluetoothDevice.add(r);
        }
      }
    });
    // Stop scanning
    new Future.delayed(const Duration(seconds: Consts.SCAN_TIMEOUT),
        () => flutterBlue.stopScan());
  }
}
