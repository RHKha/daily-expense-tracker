import 'package:base_scaffold/base_scaffold.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/app_theme/button_theme.dart';
import 'package:dailyexpenses/app_theme/input_decoration_theme.dart';
import 'package:dailyexpenses/custom_widget/background_widget.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/custom_widget/rounded_background_widget.dart';
import 'package:dailyexpenses/custom_widget/web_view_page.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/input_validator.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:dailyexpenses/utils/strings.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //Common Variables
  ThemeData themeData;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  FocusNode _emailFocusNode = FocusNode();

  //SignUp Data
  String _email = "";

  bool showLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return BaseScaffold(
      isScreenLoadingWithBackground: showLoading,
      showToolbar: false,
//      scaffoldBackgroundColor: AppConstants.PRIMARY_COLOR,
      scaffoldBackgroundColor: themeData.primaryColor,
      body: forgotPasswordBody(),
    );
  }

  Widget forgotPasswordBody() {
    return BackgroundWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          title(),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: formWidget(),
            ),
          ),
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.all(SizeUtils.get(5)),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black12,
                size: SizeUtils.get(30),
              ),
            ),
          ),
          Expanded(
            child: Text(
              CommonUtils.getText(context, AppTranslate.FORGOT_PASSWORD_TITLE),
              style:
                  themeData.textTheme.display1.copyWith(color: Colors.black12),
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }

  Widget formWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(20)),
      child: RoundedBackgroundWidget(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(
            horizontal: SizeUtils.get(15),
            vertical: SizeUtils.getWidthAsPerPercent(5)),
        child: form(),
      ),
    );
  }

  Widget form() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(10)),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: SizeUtils.getHeightAsPerPercent(2)),
            Text(
              CommonUtils.getText(
                  context, AppTranslate.FORGOT_PASSWORD_INSTRUCTIONS),
              style: themeData.textTheme.title.copyWith(
                  color: Colors.white, fontSize: SizeUtils.getFontSize(16)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(4)),
            textFieldEmail(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(8)),
            ButtonUtils.btnFillWhite(
                CommonUtils.getText(context, AppTranslate.SEND),
                () => this.btnLoginClick()),
            SizedBox(height: SizeUtils.get(10)),
          ],
        ),
      ),
    );
  }

  Widget textFieldEmail() {
    return InputTextFieldUtils.inputTextField(
        label: CommonUtils.getText(context, AppTranslate.ENTER_EMAIL),
        focusNode: _emailFocusNode,
        onFieldSubmitted: (value) {
          btnLoginClick();
        },
        isTextInputActionDone: true,
        validator: (value) => InputValidator.validateEmail(context, value),
        onSaved: (value) => _email = value,
        keyboardType: TextInputType.emailAddress);
  }

  Future<void> btnLoginClick() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      NetworkCheck networkCheck = new NetworkCheck();
      final bool isConnect = await networkCheck.check();
      if (!isConnect) {
        Dialogs.showInfoDialog(
            context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
        return;
      }

      setLoadingState(true);
      _handleSignIn();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _handleSignIn() async {
    String errorMessage = '';
    try {
      await _auth.sendPasswordResetEmail(email: _email);

      setLoadingState(false);
      CommonUtils.closeKeyboard(context);
      Dialogs.showInfoDialog(context,
          CommonUtils.getText(context, AppTranslate.EMAIL_SEND_MESSAGE),
          onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      }, isCancelable: false);
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage =
              CommonUtils.getText(context, AppTranslate.FIREBASE_INVALID_EMAIL);
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = CommonUtils.getText(
              context, AppTranslate.FIREBASE_USER_NOT_FOUND);
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = CommonUtils.getText(
              context, AppTranslate.FIREBASE_ACCOUNT_DISABLE);
          break;
        default:
          errorMessage = CommonUtils.getText(
                  context, AppTranslate.FIREBASE_UNKNOWN_ERROR) +
              " ${error.code}";
      }
      setLoadingState(false);
      Dialogs.showInfoDialog(context, errorMessage);
    }
  }

  void setLoadingState(bool isShow) {
    setState(() {
      this.showLoading = isShow;
    });
  }
}
