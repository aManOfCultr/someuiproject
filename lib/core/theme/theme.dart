import 'package:flutter/material.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    drawerTheme: DrawerThemeData(backgroundColor: Pallete.backgroundColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: _border(Pallete.darkgradient1),
      focusedBorder: _border(Pallete.gradient2),
    ),
  );
  static final lightThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    drawerTheme: DrawerThemeData(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: _border(Pallete.gradient2),
      focusedBorder: _border(Pallete.gradient1),
    ),
  );
}
