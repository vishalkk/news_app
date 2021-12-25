import 'package:flutter/material.dart';

class Colors {
  const Colors();
  static const Color mainColor = Color(0xFF64FFDA);
  static const Color secondColor = Color(0xFF64FFDA);
  static const Color grey = Color(0xFFE5E5E5);
  static const Color background = Color(0xFFf0f1f6);
  static const Color titleColor = Color(0xFFE5E5E5);
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF1DE9B6), Color(0xFF64FFDA)],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
//Teal: 0xFF1DE9B6, accnt: 0xFF64FFDA