import 'package:flutter/material.dart';
import 'package:liaou/remoteloc.dart';
import 'package:liaou/consts.dart';
import 'package:liaou/locpaint.dart';
import 'package:liaou/sizeutil.dart';
import 'package:liaou/setting.dart';

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
  final _locNums = 3; //locations
  final _locRadius = 5.0; //location circle radius
  _LiaoUHomeState() {
    for (var i = 0; i < _locNums; i++) {
      RemoteLoc item = RemoteLoc()..id = i;
      item.center = new Offset(10.0 * (i + 1), 10.0 * (i + 1));
      item.radius = _locRadius;
      if (i == 0)
        item.color = Colors.red;
      else if (i == 1)
        item.color = Colors.yellow;
      else
        item.color = Colors.blue;
      _lstRemoteLocs.add(item);
    }
  }

  //scan remote locations
  void _reScan() {
    setState(() {
      _lstRemoteLocs.forEach((item) {
        double dx = item.center.dx + 10;
        double dy = item.center.dy + 10;
        if (dx > SizeUtil.width) dx = SizeUtil.width;
        if (dy > SizeUtil.height) dy = SizeUtil.height;
        item.center = Offset(dx, dy);
      });
    });
  }
  //open setting page & get specific bluetooth device rssi & paint rssi
  //context: main page context
  Widget _paintRssi(BuildContext context) {
    return Setting();
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
          child: Container(
            width: SizeUtil.width,
            height: SizeUtil.height,
            child: CustomPaint(
              painter: LocPaint(_lstRemoteLocs), //paint remote location
            ),
          ),
        )),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _reScan,
        //   tooltip: Consts.RESCAN,
        //   child: Icon(Icons.refresh_rounded),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(Consts.EDGE_INSERT_NUM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _paintRssi(context)),
                  );
                },
                tooltip: Consts.SETTING_PAGE,
                child: Icon(Icons.settings),
              ),
              FloatingActionButton(
                onPressed: _reScan,
                tooltip: Consts.RESCAN,
                child: Icon(Icons.refresh_rounded),
              )
            ],
          ),
        ));
  }
}
