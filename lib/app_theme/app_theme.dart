import 'package:flutter/material.dart';
import 'package:dailyexpenses/app_theme/text_theme.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';
import 'package:dailyexpenses/utils/constants/font_constants.dart';

import 'button_theme.dart';
import 'input_decoration_theme.dart';

class MyAppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: FontConstants.ROBOTO,
    primaryColor: Colors.lightGreen,
    backgroundColor: Colors.white,
    buttonColor: ColorConstants.APP_THEME_COLOR,
    accentColor: ColorConstants.APP_THEME_COLOR,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    buttonTheme: buttonThemeLight(),
    textTheme: textThemeLight(),
    inputDecorationTheme: inputDecorationThemeLight(),
  );

//  static final ThemeData lightTheme = ThemeData(
//    fontFamily: FontConstants.ROBOTO,
//    primaryColor: ColorConstants.APP_THEME_COLOR,
//    buttonColor: ColorConstants.APP_THEME_COLOR,
//    accentColor: ColorConstants.APP_THEME_COLOR,
//    scaffoldBackgroundColor: Colors.white,
//    brightness: Brightness.light,
//    buttonTheme: buttonThemeLight(),
//    textTheme: textThemeLight(),
//    inputDecorationTheme: inputDecorationThemeLight(),
//  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: FontConstants.ROBOTO,
    primaryColor: ColorConstants.PRIMARY_COLOR,
    backgroundColor: Colors.black,
    buttonColor: Colors.black,
    accentColor: ColorConstants.ACCENT_DARK_COLOR,
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.light,
    buttonTheme: buttonThemeLight(),
    textTheme: textThemeDark(),
    inputDecorationTheme: inputDecorationThemeLight(),
  );
}
