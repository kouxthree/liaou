import 'package:flutter/material.dart';
import 'info.dart';

class Serv extends StatefulWidget {
  @override
  _ServState createState() => _ServState();
}

class _ServState extends State<Serv> {
  late Info _blinfo = new Info(); //beacon info
  late FloatingActionButton _beaconStatusBtn; //switch beacon status button

  @override
  void initState() {
    super.initState();
    _getBeaconStatus();
    _beaconStatusBtn =
        _getBeaconStatusBtn(_blinfo.isAdvertising ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Transmission supported: ${_blinfo.isTransmissionSupported}'),
              Text('Beacon started: ${_blinfo.isAdvertising}'),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _beaconStatusBtn,
        ],
      ),
    );
  }

  //get switch beacon status button
  FloatingActionButton _getBeaconStatusBtn(bool flag) {
    var btn;
    if (flag) {
      btn = FloatingActionButton(
        onPressed: () => _switchBeaconStatus(),
        child: Icon(Icons.present_to_all),
        backgroundColor: Colors.red,
      );
    } else {
      btn = FloatingActionButton(
        onPressed: () => _switchBeaconStatus(),
        child: Icon(Icons.present_to_all),
        backgroundColor: Colors.grey,
      );
    }
    return btn;
  }

  //start or stop beacon. make visible or invisible to others
  void _switchBeaconStatus() {
    if (_blinfo.isAdvertising) {
      //visible -> invisible
      _stopBeacon();
      _beaconStatusBtn = _getBeaconStatusBtn(false);
    } else {
      //invisible -> visible
      _startBeacon();
      _beaconStatusBtn = _getBeaconStatusBtn(true);
    }
  }

  //start beacon. make me visible to others
  void _startBeacon() {
    _blinfo.beaconBroadcast
        .setUUID(_blinfo.uuid)
        .setMajorId(_blinfo.majorId)
        .setMinorId(_blinfo.minorId)
        .setTransmissionPower(_blinfo.transmissionPower)
        .setAdvertiseMode(_blinfo.advertiseMode)
        .setIdentifier(_blinfo.identifier)
        .setLayout(_blinfo.layout)
        .setManufacturerId(_blinfo.manufacturerId)
        .setExtraData(_blinfo.extraData)
        .start();
  }

  void _stopBeacon() {
    _blinfo.beaconBroadcast.stop();
  }

  void _getBeaconStatus() {
    _blinfo.beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      setState(() {
        _blinfo.isTransmissionSupported = isTransmissionSupported;
      });
    });
    _blinfo.isAdvertisingSubscription = _blinfo.beaconBroadcast
        .getAdvertisingStateChange()
        .listen((isAdvertising) {
      setState(() {
        _blinfo.isAdvertising = isAdvertising;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_blinfo.isAdvertisingSubscription != null) {
      _blinfo.isAdvertisingSubscription.cancel();
    }
  }
}
