import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetPasscodeDialog extends StatefulWidget {
  final Function updateList;

  final bool isChangePasscode;

  const SetPasscodeDialog({Key key, this.updateList, this.isChangePasscode})
      : super(key: key);

  @override
  _SetPasscodeDialogState createState() => _SetPasscodeDialogState();
}

class _SetPasscodeDialogState extends State<SetPasscodeDialog> {
  ThemeData themeData;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  bool showLoading = false;

  String currentPasscode = "";
  String oldPasscode = "";
  String passcode = "";
  String confirmPasscode = "";
  bool isEnterPasscode = false;

  bool allowOldPasscode = false;

  @override
  void initState() {
    super.initState();
    allowOldPasscode = widget.isChangePasscode;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    List<Widget> widgetList = [];
    for (int i = 0; i < 6; i++) {
      widgetList.add(Container(
          height: SizeUtils.get(15),
          width: SizeUtils.get(15),
          margin: EdgeInsets.all(SizeUtils.get(5)),
          decoration: BoxDecoration(
              color: currentPasscode.length > i
                  ? Colors.white
                  : Colors.transparent,
              shape: BoxShape.circle,
              border:
                  Border.all(width: SizeUtils.get(2), color: Colors.white))));
    }

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.get(20))),
        title: Text(
          widget.isChangePasscode ? "Change Passcode" : "Set Passcode",
//          CommonUtils.getText(context, AppTranslate.PROFILE),
          textAlign: TextAlign.center,
          style: themeData.textTheme.headline5.copyWith(color: Colors.white),
        ),
        backgroundColor: themeData.primaryColor,
        content: Container(
          width: SizeUtils.screenWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(allowOldPasscode
                    ? "Please enter old passcode"
                    : isEnterPasscode
                        ? 'Please re-enter passcode'
                        : 'Please enter passcode'),
                SizedBox(height: SizeUtils.get(20)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widgetList),
                SizedBox(height: SizeUtils.get(20)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      numberButton(
                          number: 1,
                          onTap: () {
                            setPasscodeText("1");
                          }),
                      numberButton(
                          number: 2,
                          onTap: () {
                            setPasscodeText("2");
                          }),
                      numberButton(
                          number: 3,
                          onTap: () {
                            setPasscodeText("3");
                          }),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      numberButton(
                          number: 4,
                          onTap: () {
                            setPasscodeText("4");
                          }),
                      numberButton(
                          number: 5,
                          onTap: () {
                            setPasscodeText("5");
                          }),
                      numberButton(
                          number: 6,
                          onTap: () {
                            setPasscodeText("6");
                          }),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      numberButton(
                          number: 7,
                          onTap: () {
                            setPasscodeText("7");
                          }),
                      numberButton(
                          number: 8,
                          onTap: () {
                            setPasscodeText("8");
                          }),
                      numberButton(
                          number: 9,
                          onTap: () {
                            setPasscodeText("9");
                          }),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Opacity(opacity: 0.0, child: numberButton(number: 9)),
                      numberButton(
                          number: 0,
                          onTap: () {
                            setPasscodeText("0");
                          }),
                      textButton(
                          text: "Delete",
                          onTap: () {
                            removePasscodeLastText();
                          }),
//                      Opacity(opacity: 0.0, child: numberButton(number: 9)),
                    ]),
                SizedBox(height: SizeUtils.get(20)),
                buttonOptionsWidget(context)
              ],
            ),
          ),
        ));
  }

  Widget numberButton({number, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeUtils.get(60),
        width: SizeUtils.get(60),
        margin: EdgeInsets.all(SizeUtils.get(10)),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Text(number.toString(),
              style: themeData.textTheme.subtitle1.copyWith(
                  color: themeData.primaryColor,
                  fontSize: SizeUtils.getFontSize(25)),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget textButton({text, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeUtils.get(60),
        width: SizeUtils.get(60),
        margin: EdgeInsets.all(SizeUtils.get(10)),
        child: Center(
          child: Text(text.toString(),
              style: themeData.textTheme.subtitle1.copyWith(
                  color: Colors.white, fontSize: SizeUtils.getFontSize(16)),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget buttonOptionsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            CommonUtils.getText(context, AppTranslate.CANCEL),
            style: TextStyle(color: Colors.white),
          ),
        ),
        showLoading
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(30)),
                child: CupertinoActivityIndicator(),
              )
            : GestureDetector(
                onTap: () {
                  onClickConfirm(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.get(10),
                    vertical: SizeUtils.get(5),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      CommonUtils.getText(context, AppTranslate.SAVE),
                      style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeUtils.getFontSize(16)),
                    ),
                  ),
                ),
              )
      ],
    );
  }

  Future<void> onClickConfirm(BuildContext context) async {
    if ((oldPasscode == "" || oldPasscode.length < 6) &&
        widget.isChangePasscode) {
      Dialogs.showInfoDialog(context, "Please enter old passcode.");
      return;
    }
    if (passcode == "" || passcode.length < 6) {
      Dialogs.showInfoDialog(context, "Please enter passcode.");
      return;
    }
    if (confirmPasscode == "" || confirmPasscode.length < 6) {
      Dialogs.showInfoDialog(context, "Please re-enter passcode.");
      return;
    }
    if (passcode == confirmPasscode) {
      setState(() {
        showLoading = true;
      });

      NetworkCheck networkCheck = new NetworkCheck();
      final bool isConnect = await networkCheck.check();
      if (!isConnect) {
        Dialogs.showInfoDialog(
            context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
        return;
      }

      FirebaseUser firebaseUser = await _auth.currentUser();

      firestoreInstance
          .collection("Passcode")
          .document(firebaseUser.uid)
          .setData({
        "passcode": confirmPasscode,
        "uid": firebaseUser.uid,
      }, merge: true).then((_) {
        print("success!");
      }).whenComplete(() {
        setState(() {
          showLoading = false;
        });
        Navigator.pop(context);
        widget.updateList();
      });
    } else {
      Dialogs.showInfoDialog(context, "Please enter correct passcode");
    }
  }

  Future<void> setPasscodeText(String number) async {
    if (currentPasscode.length < 6) {
      setState(() {
        currentPasscode = currentPasscode + number;
      });
      print("Passcode :: $currentPasscode");
      if (currentPasscode.length == 6) {
        if (allowOldPasscode) {
          setState(() {
            oldPasscode = currentPasscode;
          });

          FirebaseUser firebaseUser = await _auth.currentUser();
          DocumentSnapshot documentSnapshot = await firestoreInstance
              .collection("Passcode")
              .document(firebaseUser.uid)
              .get();

          String passcode = documentSnapshot.data["passcode"];
          if (oldPasscode == passcode) {
            setState(() {
              allowOldPasscode = false;
              currentPasscode = "";
            });
            return;
          } else {
            Dialogs.showInfoDialog(
                context, "Please enter correct old passcode");
            return;
          }
        }

        if (isEnterPasscode) {
          setState(() {
            confirmPasscode = currentPasscode;
          });
          if (passcode == confirmPasscode) {
          } else {
            Dialogs.showInfoDialog(context, "Please enter correct passcode");
          }
        } else {
          setState(() {
            passcode = currentPasscode;
            currentPasscode = '';
            isEnterPasscode = true;
          });
        }
      }
    }
  }

  void removePasscodeLastText() {
    if (currentPasscode.length != 0) {
      setState(() {
        currentPasscode =
            currentPasscode.substring(0, currentPasscode.length - 1);
      });
      print("Passcode :: $currentPasscode");
      if (isEnterPasscode) {
        confirmPasscode = currentPasscode;
      } else {
        passcode = currentPasscode;
      }
    }
  }
}
