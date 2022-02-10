import 'package:flutter/material.dart';
import 'package:oxon_app/size_config.dart';
import 'package:oxon_app/theme/colors.dart';

@immutable
class AppTheme {
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 3.95 * SizeConfig.responsiveMultiplier),
          headline2: TextStyle(fontSize: 3.66 * SizeConfig.responsiveMultiplier),
          headline3: TextStyle(fontSize: 3.22 * SizeConfig.responsiveMultiplier),
          headline4: TextStyle(fontSize: 2.78 * SizeConfig.responsiveMultiplier),
          headline6: TextStyle(fontSize: 2.19 * SizeConfig.responsiveMultiplier),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white));
  }
}
