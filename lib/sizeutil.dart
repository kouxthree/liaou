import 'package:flutter/material.dart';
import 'dart:math';

class SizeUtil {
  static var _l_size = Size(1.0, 1.0); //device logic size

  //device size
  static get width {
    return _l_size.width;
  }

  static get height {
    return _l_size.height;
  }

  static set size(s) {
    _l_size = s;
  }

  //get draw coordinate
  static double getx(double w) {
    return w;
  }

  static double gety(double h) {
    return h;
  }

  static double getxy(double s) {
    return s;
  }
}
