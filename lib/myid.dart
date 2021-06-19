import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:liaou/parts/signaltypeparts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liaou/consts.dart';
import 'package:liaou/parts/ssignal.dart';
import 'package:liaou/parts/sharedparts.dart';

class MyId extends StatefulWidget {
  MyId({Key? key}) : super(key: key);
  @override
  _MyId createState() => _MyId();
}

class _MyId extends State<MyId> {
  BoxDecoration _maleDecoration = BoxDecoration();
  BoxDecoration _femaleDecoration = BoxDecoration();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _setInitData(); //set stored my id info
  }

  void _setInitData() async {
    int genderidx = await readGenderIndex();
    if (genderidx >= 0) genderTapped(Gender.values[genderidx]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildMyId()),
    );
  }

  //build myid page
  Widget _buildMyId() {
    var _icon_id = Container(
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
    var _icon_gender = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () => genderTapped(Gender.Male),
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
                  decoration: _femaleDecoration,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    var _icon_signaltype = SignalTypeParts();
    var _icon_send_ignal = SSignal();
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _icon_id,
            _icon_gender,
            _icon_signaltype,
            _icon_send_ignal,
          ],
        ),
      ),
    );
  }

  //gender icons tapped
  genderTapped(Gender gender) async {
    setState(() {
      switch (gender) {
        case Gender.Male:
          _maleDecoration = SharedParts.SelectedBox;
          _femaleDecoration = SharedParts.UnSelectedBox;
          break;
        case Gender.Female:
          _maleDecoration = SharedParts.UnSelectedBox;
          _femaleDecoration = SharedParts.SelectedBox;
          break;
        default:
          break;
      }
    });
    saveGender(gender); //save data
  }

  Future<void> saveGender(Gender gender) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(PrefKey.Gender.toString(), gender.index);
  }

  Future<int> readGenderIndex() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(PrefKey.Gender.toString()) ?? -1;
  }
}
