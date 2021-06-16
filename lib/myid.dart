import 'package:flutter/material.dart';
import 'package:liaou/consts.dart';
import 'package:emojis/emojis.dart';

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

  @override
  void initState() {
    super.initState();
    genderTapped(Gender.Female);
    int len = SendSignal.values.length;
    for (int i = 0; i < len; i++) {
      _lstSendSignalDecoration.add(new BoxDecoration());
    }
    sendSinalTapped(SendSignal.Purple);
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

  genderTapped(Gender gender) {
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
  }

  sendSinalTapped(SendSignal signal) {
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
  }

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
                onTap: () => sendSinalTapped(SendSignal.Orange),
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
                onTap: () => sendSinalTapped(SendSignal.Blue),
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
                onTap: () => sendSinalTapped(SendSignal.Purple),
                child: Container(
                  child: Icon(Icons.circle, size: 80, color: Colors.purple),
                  decoration:  _lstSendSignalDecoration[SendSignal.Purple.index],
                ),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => sendSinalTapped(SendSignal.Green),
                child: Container(
                  child: Icon(Icons.circle, size: 80, color: Colors.green),
                  decoration:  _lstSendSignalDecoration[SendSignal.Green.index],
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
}
