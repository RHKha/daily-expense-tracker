import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';

buttonThemeLight() {
  return ButtonThemeData(
      padding: const EdgeInsets.all(15.0),
      textTheme: ButtonTextTheme.primary,
      buttonColor: ColorConstants.APP_THEME_COLOR,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)));
}

class ButtonUtils {
  static Widget btnFillWhite(String title, onTap) {
    return RaisedButton(
      child: Text(title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: onTap,
      textColor: ColorConstants.APP_THEME_COLOR,
      color: Colors.white,
    );
  }

  static Widget btnFillGreen({String title, onTap, bool removeRadius = false}) {
    return RaisedButton(
      child: Text(title.toUpperCase(), textAlign: TextAlign.center),
      onPressed: onTap,
      textColor: Colors.white,
      color: ColorConstants.APP_THEME_COLOR,
      shape: removeRadius
          ? RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))
          : RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
    );
  }

  static Widget btnFillRed({String title, onTap, bool removeRadius = false}) {
    return RaisedButton(
      child: Text(title.toUpperCase(), textAlign: TextAlign.center),
      onPressed: onTap,
      textColor: Colors.white,
      color: Colors.red,
      shape: removeRadius
          ? RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0))
          : RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
    );
  }

  static Widget btnBorderWhite(String title, onTap) {
    return OutlineButton(
      child: Text(title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold)),
      onPressed: onTap,
      textColor: Colors.white,
      borderSide: BorderSide(color: Colors.white),
      highlightedBorderColor: Colors.white30,
    );
  }
}
