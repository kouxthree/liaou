//paint (remote) location
import 'package:flutter/material.dart';
import 'package:liaou/sizeutil.dart';
import 'package:liaou/remoteloc.dart';

class LocPaint extends CustomPainter {
  List<RemoteLoc> _lstRemoteLocs = [];
  LocPaint(List<RemoteLoc> _lstRemoteLocs) {
    this._lstRemoteLocs = _lstRemoteLocs;
  }
  @override
  void paint(Canvas canvas, Size size) {
    //must larger than 1.0x1.0
    if (size.width > 1.0 && size.height > 1.0) {
      SizeUtil.size = size;
    }
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..isAntiAlias = true;

    _lstRemoteLocs.forEach((item) =>
        //draw a circle as remote location
        _drawLoc(canvas, item, size, paint));
  }

  @override
  bool shouldRepaint(CustomPainter deligate) => false;
  //draw a circle
  void _drawLoc(Canvas canvas, RemoteLoc loc, Size size, paint) {
    loc.center = _cvtLSize(loc.center, size);
    var circleCenter =
        Offset(SizeUtil.getx(loc.center.dx), SizeUtil.gety(loc.center.dy));
    paint.color = loc.color;
    canvas.drawCircle(circleCenter, SizeUtil.getxy(loc.radius), paint);
    canvas.save();
    canvas.restore();
  }

  //convert logic size
  Offset _cvtLSize(Offset off, Size size) {
    return Offset(SizeUtil.getx(off.dx), SizeUtil.gety(off.dy));
  }
}
