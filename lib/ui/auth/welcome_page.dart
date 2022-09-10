import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/app_theme/button_theme.dart';
import 'package:dailyexpenses/app_theme/text_theme.dart';
import 'package:dailyexpenses/custom_widget/background_widget.dart';
import 'package:dailyexpenses/custom_widget/rounded_background_widget.dart';
import 'package:dailyexpenses/custom_widget/web_view_page.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //Common Variables
  ThemeData themeData;
  final Firestore firestoreInstance = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: welcomeBody(),
    );
  }

  Widget welcomeBody() {
    return BackgroundWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          title(),
          SizedBox(height: SizeUtils.getWidthAsPerPercent(20)),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loginSignUpWidget(),
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeUtils.getWidthAsPerPercent(10)),
                child: Center(child: termsAndPrivacyText()),
              )),
        ],
      ),
    );
  }

  Container title() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.get(30), vertical: SizeUtils.get(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppConstants.APP_NAME,
            style: themeData.textTheme.display1.copyWith(color: Colors.black12),
          )
        ],
      ),
    );
  }

  Widget loginSignUpWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(20)),
      child: RoundedBackgroundWidget(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(
            horizontal: SizeUtils.get(15),
            vertical: SizeUtils.getHeightAsPerPercent(8)),
        child: buttons(),
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            CommonUtils.getText(context, AppTranslate.KEY_WELCOME),
            style: themeData.textTheme.display1
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(10)),
          ButtonUtils.btnFillWhite(
              CommonUtils.getText(context, AppTranslate.CREATE_ACCOUNT),
              () => this.navigationPageToSignup()),
          SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
          ButtonUtils.btnBorderWhite(
              CommonUtils.getText(context, AppTranslate.LOG_IN),
              () => this.navigationPageToLogin()),
        ],
      ),
    );
  }

  Widget termsAndPrivacyText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: themeData.textTheme.subtitle.copyWith(color: Colors.redAccent),
        children: <TextSpan>[
          TextSpan(
              text: CommonUtils.getText(
                      context, AppTranslate.TERMS_AND_POLICY_TEXT_1) +
                  " "),
          TextStyleUtils.textBoldAndUnderline(
              CommonUtils.getText(
                      context, AppTranslate.TERMS_AND_POLICY_TEXT_2) +
                  " ", () async {
            DocumentSnapshot snapshot = await firestoreInstance
                .collection("URL")
                .document('terms')
                .get();
            String url = snapshot.data['url'] ?? '';
            navigateToWeb(
              CommonUtils.getText(
                  context, AppTranslate.TERMS_AND_POLICY_TEXT_2),
              url,
            );
          }),
          TextSpan(
              text: CommonUtils.getText(
                      context, AppTranslate.TERMS_AND_POLICY_TEXT_3) +
                  " "),
          TextStyleUtils.textBoldAndUnderline(
              CommonUtils.getText(
                      context, AppTranslate.TERMS_AND_POLICY_TEXT_4) +
                  " ", () async {
            DocumentSnapshot snapshot = await firestoreInstance
                .collection("URL")
                .document('privacy')
                .get();
            String url = snapshot.data['url'] ?? '';
            navigateToWeb(
              CommonUtils.getText(
                  context, AppTranslate.TERMS_AND_POLICY_TEXT_4),
              url,
            );
          }),
        ],
      ),
    );
  }

//
  void navigationPageToSignup() {
    Navigator.push(context, CommonUtils.createRoute(SignUpPage()));
  }

  void navigationPageToLogin() {
    Navigator.push(context, CommonUtils.createRoute(LoginPage()));
  }

  void navigateToWeb(String title, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(title: title, url: url)));
  }
}
