import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import '../consts.dart';
import 'statectl3.dart';

class Client extends StatefulWidget {
  Client({Key? key}) : super(key: key) {
    Get.put(StateCtl());
  }
  @override
  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  late StreamSubscription<RangingResult> _streamRanging;
  late StreamSubscription<MonitoringResult> _streamMonitoring;
  final _controller = Get.find<StateCtl>();
  final _beacons = <Beacon>[];
  late Widget _searchbtn;

  @override
  void initState() {
    super.initState();
    _searchbtn = _getSearchBtn(true);
  }

  _initScanBeacon() async {
    final regions = <Region>[
      Region(
        identifier: 'Consts.COM',
        //proximityUUID: '39ED98FF-FFFF-441A-802F-9C398FC199D2',
      ),
    ];
    _beacons.clear();
    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
          print(result);
          if (result != null && mounted) {
            setState(() {
              result.beacons.forEach((ele) {
                if(!_beacons.contains(ele)) _beacons.add(ele);
              });
              _beacons.sort(_compareParameters);
            });
          }
        });
    _streamMonitoring =
        flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
          print(result);
          if (result != null && result.region != null) {
            setState(() {});
          }
        });
    setState(() {
      _searchbtn = _getSearchBtn(false);//display stop
    });
  }
  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);
    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }
    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }
    return compare;
  }
  _pauseScanBeacon() async {
    _streamRanging.cancel();
    setState(() {
      _searchbtn = _getSearchBtn(true);//display start
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 80,
            child: buildScanResult(),
          ),
          Expanded(
            flex: 20,
            child: _searchbtn,
          ),
        ],
      ),
    );
  }
  Widget buildScanResult() {
    List<Container> containers = <Container>[];
    for (Beacon result in _beacons) {
      containers.add(
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text( result.proximityUUID,),
                    Text( 'Major: ${result.major}\nMinor: ${result.minor}'),
                    Text('Accuracy: ${result.accuracy}m\nRSSI: ${result.rssi}'),
                  ],
                ),
              ),
            ],
          ),
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
  _getSearchBtn(bool flg) {
    if (flg) {
      return TextButton(
        child: Image.asset(
          'docs/icon/搜索.ico',
          fit: BoxFit.cover,
        ),
        onPressed: () => _initScanBeacon(),
      );
    } else {
      return FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: () => _pauseScanBeacon(),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
