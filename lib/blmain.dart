import 'package:flutter_blue/flutter_blue.dart';
import 'consts.dart';

class BlMain {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<ScanResult> lstScanResult = [];
  //add scan result to list
  _addScanResultToList(final ScanResult r) {
    if (!lstScanResult.contains(r)) {
      lstScanResult.add(r);
    }
  }
  Future<List<ScanResult>> reScan() {
    // lstScanResult.clear();
    return Future.delayed(Duration(seconds: Consts.SCAN_TIMEOUT), () {
      //add scanned bluetooth device
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult r in results) {
          _addScanResultToList(r);
        }
      });
      flutterBlue.startScan();
      return lstScanResult;
    });
  }
}