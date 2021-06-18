import 'package:flutter/material.dart';

class SharedParts {
  static BoxDecoration SelectedBox = BoxDecoration(
    color: Colors.yellow[100],
    border: Border.all(
      color: Colors.red,
      width: 5,
    ),
    borderRadius: BorderRadius.circular(20),
  );
  static BoxDecoration UnSelectedBox = BoxDecoration();
}
