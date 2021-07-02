import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:liaou/parts/ssignal.dart';
import 'bl/serv.dart';
import 'bl/client.dart';
import 'remoteloc.dart';
import 'sizeutil.dart';
import 'consts.dart';
import 'locpaint.dart';

class MyHome extends StatefulWidget {
  MyHome({Key? key}) : super(key: key);
  @override
  _MyHome createState() => _MyHome();
}

class _MyHome extends State<MyHome> {
  // var _searchIcon; //Icon _searchIcon = Icon(Icons.search); //show search or search-off icon
  // bool searchingFlag = true; //is searching?
  List<RemoteLoc> _lstRemoteLocs = []; //remote locations
  // // final _locNums = 3; //locations
  // // final _locRadius = 5.0; //location circle radius
  late Client _client;

  _MyHome() {
    _client = new Client();
    // _searchIcon = getSearchIcon(false);
  }

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i < _locNums; i++) {
    //   RemoteLoc item = RemoteLoc()..id = i;
    //   item.center = new Offset(10.0 * (i + 1), 10.0 * (i + 1));
    //   item.radius = _locRadius;
    //   if (i == 0)
    //     item.color = Colors.red;
    //   else if (i == 1)
    //     item.color = Colors.yellow;
    //   else
    //     item.color = Colors.blue;
    //   _lstRemoteLocs.add(item);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildMyHome()),
    );
  }

  //scan remote locations
  // void _reScan() {
  //   requestPermission();
  //   setState(() {
  //     _lstRemoteLocs.forEach((item) {
  //       double dx = item.center.dx + 10;
  //       double dy = item.center.dy + 10;
  //       if (dx > SizeUtil.width) dx = SizeUtil.width;
  //       if (dy > SizeUtil.height) dy = SizeUtil.height;
  //       item.center = Offset(dx, dy);
  //     });
  //   });
  // }
  // FractionallySizedBox(
  // widthFactor: 0.65, // between 0 and 1
  // heightFactor: 1.0,
  // child:Container(color: Colors.red
  // ,),
  // )
  //build myhome page
  Widget _buildMyHome() {
    return Scaffold(
      body: Container(
        // width: SizeUtil.width,
        // height: SizeUtil.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 30,
              child: _client,
            ), //My Client/Remote Status
            Expanded(
              flex: 30,
              child: CustomPaint(
                painter: LocPaint(_lstRemoteLocs), //paint remote location
              ),
            ),
            Expanded(
              flex: 40,
              child: Serv(),
            ), //My Status Service/My Status
            // Expanded(
            //   flex: 10,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
                  // _searchIcon,
                  //SSignal(),
                  // FloatingActionButton(
                  //   onPressed: _onSendIconTapped,
                  //   child: Icon(Icons.present_to_all),
                  //   backgroundColor: Colors.red,
                  // ),
              //   ],
              // ),
            // ),
          ],
        ),
      ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniStartDocked,
      // floatingActionButton: _searchIcon,
    );
  }

  // //get search icon
  // FloatingActionButton getSearchIcon(bool flag) {
  //   var searchicon;
  //   if (flag) {
  //     searchicon = FloatingActionButton(
  //       onPressed: _onSearchIconTapped,
  //       child: Icon(Icons.search),
  //       backgroundColor: Colors.blue,
  //     );
  //   } else {
  //     searchicon = FloatingActionButton(
  //       onPressed: _onSearchIconTapped,
  //       child: Icon(Icons.search_off),
  //       backgroundColor: Colors.grey,
  //     );
  //   }
  //   return searchicon;
  // }
  //
  // //search icon tapped
  // void _onSearchIconTapped() async {
  //   _client.fb.stopScan();
  //   setState(() {
  //     if (searchingFlag) {
  //       _searchIcon = getSearchIcon(false);
  //       searchingFlag = false; //turn off searching
  //     } else {
  //       _searchIcon = getSearchIcon(true);
  //       searchingFlag = true; //turn on searching
  //     }
  //   });
  //   if (searchingFlag) _client.startScan();
  // }
  // //send icon tapped
  // void _onSendIconTapped() {
  //   setState(() {});
  // }
}
