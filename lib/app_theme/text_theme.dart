import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';

textThemeLight() {
  return TextTheme(
      caption: new TextStyle(),
      subhead: new TextStyle(color: Colors.white),
      display1: new TextStyle(color: Colors.black26),
      title: new TextStyle(color: ColorConstants.APP_THEME_COLOR),
      subtitle: new TextStyle(color: ColorConstants.APP_THEME_COLOR),
      button: new TextStyle(
          color: ColorConstants.APP_THEME_COLOR,
          fontSize: SizeUtils.getFontSize(16)));
}

textThemeDark() {
  return TextTheme(
      caption: new TextStyle(color: Colors.white54),
      subhead: new TextStyle(color: ColorConstants.TEXT_GREY),
      display1: new TextStyle(color: Colors.white24),
      title: new TextStyle(color: ColorConstants.APP_THEME_COLOR),
      subtitle: new TextStyle(color: ColorConstants.APP_THEME_COLOR),
      button: new TextStyle(
          color: ColorConstants.APP_THEME_COLOR,
          fontSize: SizeUtils.getFontSize(16)));
}

class TextStyleUtils {
  static TextSpan textBoldAndUnderline(title, onTap) {
    return TextSpan(
      text: title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onTap,
    );
  }

  static TextStyle authTitleStyle(themeData) {
    return themeData.textTheme.display
        .copyWith(fontSize: SizeUtils.getFontSize(28));
  }

  static TextStyle authSubTitleStyle(themeData) {
    return themeData.textTheme.subhead;
  }
}
