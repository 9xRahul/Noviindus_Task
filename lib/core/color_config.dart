import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConfig {
  ColorConfig._(); // Private constructor → prevents instantiation
  static Color primary = Color.fromARGB(255, 164, 216, 216);
  static Color primaryGreen = const Color(0xFF0B6A3E); // deep green for button
  static Color borderGrey = Colors.grey.shade300;
  static Color fillGrey = Colors.grey.shade200;
  static Color iconColor = Color(0xFF010101);
  static Color textWhite = Color(0xFFFFFFFF);

  static Color patientCardGreen = Color(0xFF006837);
  static Color patientCardGrey = Color(0xFFF1F1F1);
  static Color patientCardRed = Color(0xFFF24E1E);
  static Color pureBlack = Color(0xFF000000);

  static String loginToHeadingColorCode = "404040";
}
