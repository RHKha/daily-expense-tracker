import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/app_theme/input_decoration_theme.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final Function updateList;

  const FeedbackDialog({Key key, this.updateList}) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerMessage = TextEditingController();

  ThemeData themeData;
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _message = "";

  bool _autoValidate = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.get(20))),
        title: Text(
          CommonUtils.getText(context, AppTranslate.FEEDBACK),
//          CommonUtils.getText(context, AppTranslate.PROFILE),
          textAlign: TextAlign.center,
          style: themeData.textTheme.display1.copyWith(color: Colors.white),
        ),
        backgroundColor: themeData.primaryColor,
        content: Container(
          width: SizeUtils.screenWidth,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: SizeUtils.get(20)),
                  messageWidget(),
                  SizedBox(height: SizeUtils.get(20)),
                  buttonOptionsWidget(context)
                ],
              ),
            ),
          ),
        ));
  }

  Widget titleWidget() {
    return InputTextFieldUtils.inputTextField(
      controller: _controllerTitle,
//      label: CommonUtils.getText(context, AppTranslate.USERNAME),
      label: CommonUtils.getText(context, AppTranslate.TITLE),
      capsText: true,
      maxLength: 40,
      style:
          TextStyle(fontSize: SizeUtils.getFontSize(18), color: Colors.black),
      onSaved: (value) => _title = value,
      validator: (value) {
        if (value.isEmpty) {
//          return CommonUtils.getText(
//              context, AppTranslate.PLEASE_ENTER_USERNAME);
          return CommonUtils.getText(context, AppTranslate.ENTER_TITLE);
        }
        return null;
      },
    );
  }

  Widget messageWidget() {
    return InputTextFieldUtils.inputTextField(
      controller: _controllerMessage,
//      label: CommonUtils.getText(context, AppTranslate.USERNAME),
      label: CommonUtils.getText(context, AppTranslate.MESSAGE),
      maxLength: 40,
      style:
          TextStyle(fontSize: SizeUtils.getFontSize(18), color: Colors.black),
      onSaved: (value) => _message = value,
      validator: (value) {
        if (value.isEmpty) {
          return CommonUtils.getText(context, AppTranslate.ENTER_MESSAGE);
//          return CommonUtils.getText(
//              context, AppTranslate.PLEASE_ENTER_USERNAME);
        }
        return null;
      },
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
                      CommonUtils.getText(context, AppTranslate.SEND),
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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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

      FirebaseUser user = await _auth.currentUser();

      firestoreInstance.collection("Feedback").add({
        "uid": user.uid,
        "username": user.displayName,
        "title": _title,
        "message": _message,
      }).then((value) {
        print("success!");
      }).whenComplete(() {
        setState(() {
          showLoading = false;
        });

        Navigator.pop(context);
        widget.updateList();
      });
    } else {
      _autoValidate = true;
    }
  }
}
