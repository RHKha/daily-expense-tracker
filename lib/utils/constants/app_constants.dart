import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';
import 'package:dailyexpenses/utils/strings.dart';

abstract class AppConstants {
  static const String APP_NAME = "Daily Expenses";
  static const String EMAIL_PATTERN =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static final DEVICE_TYPE = Platform.isAndroid ? "A" : "I";

  static bool USER_TYPE_IS_ASST_COACH = false;

  static String CURRENCY_VALUE = Strings.RUPEE;

  static const String TYPE_CREDIT = "1";
  static const String TYPE_DEBIT = "2";
}
