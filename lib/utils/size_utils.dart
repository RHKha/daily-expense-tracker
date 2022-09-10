import 'package:flutter/cupertino.dart';

class SizeUtils {
  static double _widthMultiplier;
  static double _heightMultiplier;
  static double screenWidth;
  static double screenHeight;

  static void init(BoxConstraints boxConstraints, Orientation orientation) {
    screenWidth = boxConstraints.maxWidth;
    screenHeight = boxConstraints.maxHeight;
    if (orientation == Orientation.portrait) {
      _widthMultiplier = boxConstraints.maxWidth / 100;
      _heightMultiplier = boxConstraints.maxHeight / 100;
    } else {
      _widthMultiplier = boxConstraints.maxHeight / 100;
      _heightMultiplier = boxConstraints.maxWidth / 100;
    }
  }

  static double get(double size) {
    if (screenWidth < 600) {
      return size;
    } else {
      return size * 1.5;
    }
  }

  static double getFontSize(double size) {
    if (screenWidth == null) {
      return size;
    }
    if (screenWidth < 600) {
      return size;
    } else {
      return size * 1.5;
    }
  }

  static double getHeightAsPerPercent(double percent) {
    return screenHeight * (percent / 100);
  }

  static double getWidthAsPerPercent(double percent) {
    return screenWidth * (percent / 100);
  }
}
