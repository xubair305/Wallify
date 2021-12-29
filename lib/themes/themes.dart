import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color(0xFF3B2577),
    secondaryHeaderColor: const Color(0xFF422F81),
    cardColor: const Color(0xFFFFFFFF),
    indicatorColor: const Color(0xFF303030),
  );
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color(0xff102A43),
    secondaryHeaderColor: const Color(0xFF243B53),
    cardColor: const Color(0xFF121212),
    indicatorColor: const Color(0xFFFFFFFF),
  );
}

extension CustomColorSchemeX on ColorScheme {
  Color? get bottomSheetIconColor {
    return brightness == Brightness.light
        ? const Color(0xFF422F81)
        : const Color(0xFF0082FF);
  }
}
