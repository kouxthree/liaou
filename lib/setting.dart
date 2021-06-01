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
  List<ScanResult> _lstScanResult = [];
  @override
  void initState() {
    super.initState();
    _reScan();
  }
  //rescan bluetooth devices
  Future<void> _reScan() async {
    setState(() async {
      _lstScanResult = await blMain.reScan();
    });
  }
  //get specific bluetooth device rssi
  _getRssi(ScanResult r) {
    // var subscription = blMain..scanResults.listen((scanResult) {
    //   // do something with scan result
    //   device = scanResult.device;
    //   print('${device.name} found! rssi: ${scanResult.rssi}');
    // });
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
                    Text(r.device.name == '' ? Consts.DEVICE_UNKNOWN : r.device.name),
                    Text(r.device.id.toString()),
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Consts.SETTING_PAGE),
        ),
        body: _buildBluetoothListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: _reScan,
          tooltip: Consts.RESCAN,
          child: Icon(Icons.refresh_rounded),
        ),
      );
}
