import 'package:flutter/material.dart';
import 'package:oxon_app/theme/colors.dart';

@immutable
class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 27.0),
          headline2: TextStyle(fontSize: 25.0),
          headline3: TextStyle(fontSize: 22.0),
          headline6: TextStyle(fontSize: 15.0),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white));
  }
}
