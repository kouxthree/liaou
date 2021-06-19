import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liaou/consts.dart';
import 'package:liaou/parts/sharedparts.dart';

class SSignal extends StatefulWidget {
  SSignal({Key? key}) : super(key: key);
  @override
  _SSignal createState() => _SSignal();
}

class _SSignal extends State<SSignal> {
  List<BoxDecoration> _lstSendSignalDecoration = [];
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    int len = SendSignal.values.length;
    for (int i = 0; i < len; i++) {
      _lstSendSignalDecoration.add(new BoxDecoration());
    }
    _setInitData(); //set stored info
  }

  void _setInitData() async {
    int signalidx = await readSendSignalIndex();
    if (signalidx >= 0) sendSignalTapped(SendSignal.values[signalidx]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () => sendSignalTapped(SendSignal.Orange),
                child: Container(
                  child: Icon(Icons.circle, size: 60, color: Colors.orange),
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
                  child: Icon(Icons.circle, size: 60, color: Colors.blue),
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
                  child: Icon(Icons.circle, size: 60, color: Colors.purple),
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
                  child: Icon(Icons.circle, size: 60, color: Colors.green),
                  decoration: _lstSendSignalDecoration[SendSignal.Green.index],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //send signal icons tapped
  sendSignalTapped(SendSignal signal) async {
    setState(() {
      int len = SendSignal.values.length;
      int selectedIdx = signal.index;
      for (int i = 0; i < len; i++) {
        if (i == selectedIdx) {
          _lstSendSignalDecoration[i] = SharedParts.SelectedBox;
        } else {
          _lstSendSignalDecoration[i] = SharedParts.UnSelectedBox;
        }
      }
    });
    saveSendSignal(signal); //save data
  }

  Future<void> saveSendSignal(SendSignal signal) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(PrefKey.SendSignal.toString(), signal.index);
  }

  Future<int> readSendSignalIndex() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(PrefKey.SendSignal.toString()) ?? -1;
  }
}
