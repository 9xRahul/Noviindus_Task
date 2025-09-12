import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConfig {
  ColorConfig._(); // Private constructor → prevents instantiation
  static Color primary = Color.fromARGB(255, 164, 216, 216);
  static Color primaryGreen = const Color(0xFF0B6A3E); // deep green for button
  static Color borderGrey = Colors.grey.shade300;
  static Color fillGrey = Colors.grey.shade200;

  static String loginToHeadingColorCode = "404040";
}
