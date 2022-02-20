import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static late double responsiveMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    responsiveMultiplier = _blockHeight;

    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    // print("responsiveMultiplier value = $responsiveMultiplier");

    if (screenHeight > 600) {
      responsiveMultiplier *= 0.8;
    }
  }
}
