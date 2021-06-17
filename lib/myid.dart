import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'consts.dart';

class MyId extends StatefulWidget {
  MyId({Key? key}) : super(key: key);
  @override
  _MyId createState() => _MyId();
}

class _MyId extends State<MyId> {
  BoxDecoration _selectedBox = BoxDecoration(
    color: Colors.yellow[100],
    border: Border.all(
      color: Colors.red,
      width: 5,
    ),
    borderRadius: BorderRadius.circular(20),
  );
  BoxDecoration _unSelectedBox = BoxDecoration();
  BoxDecoration _maleDecoration = BoxDecoration();
  BoxDecoration _feMaleDecoration = BoxDecoration();
  List<BoxDecoration> _lstSendSignalDecoration = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    int len = SendSignal.values.length;
    for (int i = 0; i < len; i++) {
      _lstSendSignalDecoration.add(new BoxDecoration());
    }
    _setInitData();//set stored my id info
  }

  void _setInitData() async {
    int genderidx = await readGenderIndex();
    int signalidx = await readSendSignalIndex();
    if (genderidx >= 0) genderTapped(Gender.values[genderidx]);
    if (signalidx >= 0) sendSignalTapped(SendSignal.values[signalidx]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(Consts.MY_ID_PAGE),
      // ),
      body: Center(child: _buildMyId()),
    );
  }

  //build myid page
  Widget _buildMyId() {
    var icon_id = Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'img/pavlova.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
    var icon_gender = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () => genderTapped(Gender.Male), // handle your onTap here
              child: Container(
                child: Text(Emojis.man, style: TextStyle(fontSize: 80)),
                decoration: _maleDecoration,
              ),
            ),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () =>
                    genderTapped(Gender.Female), // handle your onTap here
                child: Container(
                  child: Text(Emojis.woman, style: TextStyle(fontSize: 80)),
                  decoration: _feMaleDecoration,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    var icon_send_signal = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () => sendSignalTapped(SendSignal.Orange),
                child: Container(
                  child: Icon(Icons.circle, size: 80, color: Colors.orange),
                  decoration: _lstSendSignalDecoration[SendSignal.Orange.index],
                ),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => sendSignalTapped(SendSignal.Blue),
                child: Container(
                  child: Icon(Icons.circle, size: 80, color: Colors.blue),
                  decoration: _lstSendSignalDecoration[SendSignal.Blue.index],
                ),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => sendSignalTapped(SendSignal.Purple),
                child: Container(
                  child: Icon(Icons.circle, size: 80, color: Colors.purple),
                  decoration: _lstSendSignalDecoration[SendSignal.Purple.index],
                ),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => sendSignalTapped(SendSignal.Green),
                child: Container(
                  child: Icon(Icons.circle, size: 80, color: Colors.green),
                  decoration: _lstSendSignalDecoration[SendSignal.Green.index],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon_id,
          icon_gender,
          icon_send_signal,
        ],
      ),
    );
  }

  //gender icons tapped
  genderTapped(Gender gender) async {
    setState(() {
      switch (gender) {
        case Gender.Male:
          _maleDecoration = _selectedBox;
          _feMaleDecoration = _unSelectedBox;
          break;
        case Gender.Female:
          _maleDecoration = _unSelectedBox;
          _feMaleDecoration = _selectedBox;
          break;
        default:
          break;
      }
    });
    saveGender(gender);//save data
  }

  //send signal icons tapped
  sendSignalTapped(SendSignal signal) async {
    setState(() {
      int len = SendSignal.values.length;
      int selectedIdx = signal.index;
      for (int i = 0; i < len; i++) {
        if (i == selectedIdx) {
          _lstSendSignalDecoration[i] = _selectedBox;
        } else {
          _lstSendSignalDecoration[i] = _unSelectedBox;
        }
      }
    });
    saveSendSignal(signal);//save data
  }

  Future<void> saveGender(Gender gender) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(PrefKey.Gender.toString(), gender.index);
  }

  Future<void> saveSendSignal(SendSignal signal) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(PrefKey.SendSignal.toString(), signal.index);
  }

  Future<int> readGenderIndex() async {
    final SharedPreferences prefs = await _prefs;
    int? a = prefs.getInt(PrefKey.Gender.toString());
    return prefs.getInt(PrefKey.Gender.toString()) ?? -1;
  }

  Future<int> readSendSignalIndex() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(PrefKey.SendSignal.toString()) ?? -1;
  }
}
