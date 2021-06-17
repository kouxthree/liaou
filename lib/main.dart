import 'package:flutter/material.dart';
import 'myhome.dart';
import 'permit.dart';
import 'consts.dart';
import 'sizeutil.dart';
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
  int _selectedBottomeMenuItemIndex = 0; //bottom menu item index
  Widget _widgetHome = Container(); //home page
  Widget _widgetMyId = Container(); //myid page
  Widget _selectedPage = Container(); //currently selected page

  List<Widget> _lstPages = []; //home page + myid page

  _LiaoUHomeState() {
    requestPermission(); //request permission

    _widgetHome = MyHome(); //home page
    _widgetMyId = MyId(); //my id page
    _lstPages.add(_widgetHome);
    _lstPages.add(_widgetMyId);
    _selectedPage = _widgetHome;
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
