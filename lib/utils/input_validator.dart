import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/strings.dart';

import 'app_translate.dart';
import 'constants/app_constants.dart';

mixin InputValidator {
  static const int PASS_TYPE_PASSWORD = 0;
  static const int PASS_TYPE_OLD_PASSWORD = 1;
  static const int PASS_TYPE_NEW_PASSWORD = 2;

  static String validateEmail(context, String value) {
    Pattern pattern = AppConstants.EMAIL_PATTERN;
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty) {
      return CommonUtils.getText(context, AppTranslate.PLEASE_ENTER_EMAIL);
    } else if (!regex.hasMatch(value)) {
      return CommonUtils.getText(context, AppTranslate.INVALID_EMAIL);
    }
    return null;
  }

  /// passType : It is type of password for e.g :
  /// Password(0),
  /// OldPassword(1),
  /// NewPassword(2),
  static String validatePassword(context, String value,
      {int passType = PASS_TYPE_PASSWORD}) {
    if (value.isEmpty) {
      if (passType == PASS_TYPE_OLD_PASSWORD) {
        return CommonUtils.getText(
            context, AppTranslate.PLEASE_ENTER_OLD_PASSWORD);
      } else if (passType == PASS_TYPE_NEW_PASSWORD) {
        return CommonUtils.getText(
            context, AppTranslate.PLEASE_ENTER_NEW_PASSWORD);
      } else {
        return CommonUtils.getText(context, AppTranslate.PLEASE_ENTER_PASSWORD);
      }
    } else if (value.length < 8) {
      return CommonUtils.getText(context, AppTranslate.INVALID_PASSWORD);
    }
    return null;
  }

  static String validateUserName(context, value) {
    if (value.isEmpty) {
      return CommonUtils.getText(context, AppTranslate.PLEASE_ENTER_USER_NAME);
    } else if (value.length < 2) {
      return CommonUtils.getText(context, AppTranslate.INVALID_USER_NAME);
    }
    return null;
  }

  static validateConfirmPassword(context, value, String password) {
    if (value.isEmpty) {
      return CommonUtils.getText(
          context, AppTranslate.PLEASE_ENTER_CONFIRM_PASSWORD);
    } else if (value.length < 8) {
      return CommonUtils.getText(
          context, AppTranslate.INVALID_CONFIRM_PASSWORD);
    } else if (value != password) {
      return CommonUtils.getText(context, AppTranslate.PASSWORD_NOT_MATCH);
    }
    return null;
  }
}
