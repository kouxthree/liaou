import 'package:flutter/material.dart';
import 'info.dart';

class Serv extends StatefulWidget {
  @override
  _ServState createState() => _ServState();
}

class _ServState extends State<Serv> {
  Info _blinfo = new Info();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Transmission supported: ${_blinfo.isTransmissionSupported}'),
              Text('Beacon started: ${_blinfo.isAdvertising}'),
              Center(
                child: TextButton(
                  onPressed: _startBeacon,
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
    setState(() {
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
    });
  }

  void _stopBeacon() {
    setState(() {
      _blinfo.beaconBroadcast.stop();
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