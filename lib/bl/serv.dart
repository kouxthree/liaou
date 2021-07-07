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
                      'Transmission supported:',
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      'Beacon started: ${_blinfo.isAdvertising}',
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
    if (_blinfo.isAdvertising) {
      //visible -> invisible
      _stopBeacon();
    } else {
      //invisible -> visible
      _startBeacon();
    }
    _getBeaconStatus();
  }

  //start beacon. make me visible to others
  void _startBeacon() {
  }

  void _stopBeacon() {
  }

  void _getBeaconStatus() {
  }

  @override
  void dispose() {
    super.dispose();
  }
}
