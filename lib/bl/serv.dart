import 'package:flutter/material.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class Serv extends StatefulWidget {
  @override
  _ServState createState() => _ServState();
}

class _ServState extends State<Serv> {
  final FlutterBlePeripheral blePeripheral = FlutterBlePeripheral();
  final AdvertiseData _data = AdvertiseData();
  bool _isBroadcasting = false;

  late FloatingActionButton _beaconStatusBtn; //switch beacon status button

  @override
  void initState() {
    super.initState();

    _data.includeDeviceName = true;
    _data.uuid = 'bf27730d-860a-4e09-889c-2d8b6a9e0fe7';
    _data.manufacturerId = 1234;
    _data.timeout = 1000;
    _data.manufacturerData = [1, 2, 3, 4, 5, 6];
    _data.txPowerLevel = AdvertisePower.ADVERTISE_TX_POWER_ULTRA_LOW;
    _data.advertiseMode = AdvertiseMode.ADVERTISE_MODE_LOW_LATENCY;

    _getBeaconStatus();
    _beaconStatusBtn = _getBeaconStatusBtn(_isBroadcasting ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _beaconStatusBtn,
              ],
            ),
          ),
          Expanded(
            flex: 90,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'uuid:${_data.uuid}',
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      'Beacon started: ${_isBroadcasting}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //get switch beacon status button
  FloatingActionButton _getBeaconStatusBtn(bool flag) {
    var btn;
    setState(() {
      if (flag) {
        btn = FloatingActionButton(
          onPressed: () => _switchBeaconStatus(),
          child: Icon(Icons.present_to_all),
          backgroundColor: Colors.blue,
        );
      } else {
        btn = FloatingActionButton(
          onPressed: () => _switchBeaconStatus(),
          child: Icon(Icons.present_to_all),
          backgroundColor: Colors.grey,
        );
      }
    });
    return btn;
  }

  //start or stop beacon. make visible or invisible to others
  void _switchBeaconStatus() {
    if (_isBroadcasting) {
      //visible -> invisible
      _stopBeacon();
    } else {
      //invisible -> visible
      _startBeacon();
    }
    _getBeaconStatus();
  }

  //start beacon. make me visible to others
  void _startBeacon() async {
    await blePeripheral.start(_data);
    setState(() {
      _isBroadcasting = true;
    });
  }

  void _stopBeacon() async {
    await blePeripheral.stop();
    setState(() {
      _isBroadcasting = false;
    });
  }

  void _getBeaconStatus() async {
    var isAdvertising = await blePeripheral.isAdvertising();
    setState(() {
      _isBroadcasting = isAdvertising;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopBeacon();
  }
}
