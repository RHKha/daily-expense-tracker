import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/strings.dart';

class Dialogs {
  /// Show info dialogs with OK button
  static showInfoDialog(BuildContext context, String message,
      {Function onPressed, bool isCancelable = true, String buttonText}) async {
    String btnText =
        buttonText ?? CommonUtils.getText(context, AppTranslate.OK);
    String title = AppConstants.APP_NAME;

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
            onPressed: onPressed ??
                () {
                  Navigator.pop(context);
                },
            child: Text(btnText)),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// Show dialogs with three option buttons
  static showDialogWithTwoOptions(
      BuildContext context, String message, String positiveButtonText,
      {Function onCancelClick,VoidCallback positiveButtonCallBack, bool isCancelable = true}) async {
    String btnText = CommonUtils.getText(context, AppTranslate.CANCEL);
    String title = AppConstants.APP_NAME;

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
            onPressed: positiveButtonCallBack, child: Text(positiveButtonText)),
        CupertinoDialogAction(
            onPressed: onCancelClick ?? () {
              Navigator.pop(context);
            },
            child: Text(btnText)),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static bottomSheetDialog({context, title, List<String> optionList, onTap}) {
    List<Widget> widgetList = List();

    for (int i = 0; i < optionList.length; i++) {
      widgetList.add(CupertinoActionSheetAction(
        child: Text(optionList[i]),
        onPressed: () {
          Navigator.pop(context);
          onTap(i);
        },
      ));
    }

    final act = CupertinoActionSheet(
        title: Text(title),
        actions: widgetList,
        cancelButton: CupertinoActionSheetAction(
          child: Text(CommonUtils.getText(context, AppTranslate.CANCEL)),
          onPressed: () {
            Navigator.pop(context);
          },
        ));

    showCupertinoModalPopup(
        context: context, builder: (BuildContext context) => act);
  }
}
