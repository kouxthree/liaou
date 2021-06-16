import 'package:flutter/material.dart';
import 'package:liaou/permit.dart';
import 'package:liaou/remoteloc.dart';
import 'package:liaou/consts.dart';
import 'package:liaou/locpaint.dart';
import 'package:liaou/sizeutil.dart';
// import 'package:liaou/setting.dart';

import 'myid.dart';

void main() => runApp(LiaoU());

class LiaoU extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Consts.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LiaoUHome(),
    );
  }
}

class LiaoUHome extends StatefulWidget {
  LiaoUHome({Key? key}) : super(key: key);

  @override
  _LiaoUHomeState createState() => _LiaoUHomeState();
}

class _LiaoUHomeState extends State<LiaoUHome> {
  List<RemoteLoc> _lstRemoteLocs = []; //remote locations
  // final _locNums = 3; //locations
  // final _locRadius = 5.0; //location circle radius
  int _selectedBottomeMenuItemIndex = 0; //bottom menu item index
  Widget _widgetHome = Container(); //home page
  Widget _widgetMyId = Container(); //myid page
  Widget _selectedPage = Container(); //currently selected page
  var _searchIcon; //Icon _searchIcon = Icon(Icons.search); //show search or search-off icon

  bool searchingFlag = true; //is searching?
  List<Widget> _lstPages = []; //home page + myid page

  _LiaoUHomeState() {
    requestPermission(); //request permission
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
    //home page
    _widgetHome = Container(
      width: SizeUtil.width,
      height: SizeUtil.height,
      child: CustomPaint(
        painter: LocPaint(_lstRemoteLocs), //paint remote location
      ),
    );
    _widgetMyId = MyId();
    _lstPages.add(_widgetHome);
    _lstPages.add(_widgetMyId);
    _selectedPage = _widgetHome;
    _searchIcon = getSearchIcon(true);
  }

  //an alert dialog
  void alert(String msg) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(Consts.APP_NAME),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context), //openAppSettings(),
            ),
          ],
        );
      },
    );
  }

  //permission request
  void requestPermission() async {
    Permit permit = Permit();
    if (!await permit.requestPermission()) alert(Consts.PERMISSION_MSG);
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

  //paint a bluetooth device's rssi (sample points)
  // void paintRssi(List<int> lstRssi) {}

  //bottom menu tapped
  void _onBottomMenuItemTapped(int index) {
    setState(() {
      _selectedBottomeMenuItemIndex = index;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MyId()),
      // );
      if (index == 0) {
        //Home
        _selectedPage = _widgetHome;
      } else if (index == 1) {
        //MyId
        _selectedPage = _widgetMyId;
      }
    });
  }

  //get search icon
  FloatingActionButton getSearchIcon(bool flag) {
    var searchicon;
    if (flag) {
      searchicon = FloatingActionButton(
        onPressed: _onSearchIconTapped,
        child: Icon(Icons.search),
        backgroundColor: Colors.blue,
      );
    } else {
      searchicon = FloatingActionButton(
        onPressed: _onSearchIconTapped,
        child: Icon(Icons.search_off),
        backgroundColor: Colors.grey,
      );
    }
    return searchicon;
  }
  //search icon tapped
  void _onSearchIconTapped() {
    setState(() {
      if (searchingFlag) {
        _searchIcon = getSearchIcon(false);
        searchingFlag = false; //turn off searching
      } else {
        _searchIcon = getSearchIcon(true);
        searchingFlag = true; //turn on searching
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeUtil.size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(Consts.APP_NAME),
      ),
      body: Container(
          child: Center(
        child: _selectedPage,
      )),
      bottomNavigationBar: BottomNavigationBar(
        //items: const <BottomNavigationBarItem>[
        items: [
          // BottomNavigationBarItem(
          //     icon: _searchIcon, label: Consts.RESCAN),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: Consts.HOME_PAGE,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: Consts.MY_ID_PAGE,
          ),
        ],
        currentIndex: _selectedBottomeMenuItemIndex,
        selectedItemColor: Colors.amberAccent,
        onTap: _onBottomMenuItemTapped,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: _searchIcon,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _onSearchIconTapped,
      //   // tooltip: Consts.RESCAN,
      //   child: _searchIcon,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(Consts.EDGE_INSERT_NUM),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       FloatingActionButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => Setting()),
      //           );
      //         },
      //         tooltip: Consts.SETTING_PAGE,
      //         heroTag: 'setting',
      //         child: Icon(Icons.settings),
      //       ),
      //       FloatingActionButton(
      //         onPressed: _reScan,
      //         tooltip: Consts.RESCAN,
      //         heroTag: 'rescan',
      //         child: Icon(Icons.refresh_rounded),
      //       )
      //     ],
      //   ),
      // ));
    );
  }
}
