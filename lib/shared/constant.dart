import 'package:flutter/material.dart';

class Constant {
  final BuildContext context;
  Constant(this.context);

  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenWidth => MediaQuery.of(context).size.width;
  double get width => screenWidth;
  double get height => screenHeight;
}

const primaryColor = Color(0xFFB9D2D2);
const secondaryColor = Color(0xFF247881);
