import 'package:flutter/material.dart';
import 'info.dart';

class Serv extends StatefulWidget {
  @override
  _ServState createState() => _ServState();
}

class _ServState extends State<Serv> {
  late Info _blinfo = new Info();

  @override
  void initState() {
    super.initState();
    _getBeaconStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
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
              Center(
                child: TextButton(
                  onPressed: () => _startBeacon(),
                  child: Text('START'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _stopBeacon,
                  child: Text('STOP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
