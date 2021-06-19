import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liaou/consts.dart';

class SignalTypeParts extends StatefulWidget {
  SignalTypeParts({Key? key}) : super(key: key);
  @override
  _SignalTypeParts createState() => _SignalTypeParts();
}

class _SignalTypeParts extends State<SignalTypeParts> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Icon _audio = Icon(Icons.volume_up_sharp, size: 60);
  Icon _flash = Icon(Icons.flash_on, size: 60);
  int _signaltypeidx = SignalType.Audio.index;
  var _signaltype;

  @override
  void initState() {
    super.initState();
    _setInitData(); //set stored info
  }

  void _setInitData() async {
    _signaltypeidx = await readSignalTypeParts();
    if(_signaltypeidx >= 0) _signaltype = getSignalTypeIcon(_signaltypeidx);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              GestureDetector(
                onVerticalDragEnd: (detail) => SignalTypePartsSwiped(detail),
                child: _signaltype,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Icon getSignalTypeIcon(int signaltypeidx) {
    Icon signaltype = _audio;
    if (signaltypeidx == SignalType.Flash.index) signaltype = _flash;
    return signaltype;
  }

  //signal type swipped
  SignalTypePartsSwiped(DragEndDetails detail) {
    setState(() {
      //   int sensitivity = 8;
      //   if (details.delta.dy > sensitivity) {
      //     // Down Swipe
      //   } else if(details.delta.dy < -sensitivity){
      //     // Up Swipe
      //   }
      // }
      if (_signaltypeidx == SignalType.Audio.index) {
        _signaltypeidx = SignalType.Flash.index;
      } else if (_signaltypeidx == SignalType.Flash.index) {
        _signaltypeidx = SignalType.Audio.index;
      }
      saveSignalTypeParts(_signaltypeidx);
      _signaltype = getSignalTypeIcon(_signaltypeidx);
    }); //save data
  }

  Future<void> saveSignalTypeParts(int signaltypeidx) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(PrefKey.SignalType.toString(), signaltypeidx);
  }

  Future<int> readSignalTypeParts() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(PrefKey.SignalType.toString()) ?? -1;
  }
}
