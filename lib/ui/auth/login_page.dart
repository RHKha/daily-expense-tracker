import 'package:base_scaffold/base_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../main_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Common Variables
  ThemeData themeData;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  //SignUp Data
  String _email = "";
  String _password = "";

  /// Email: pinkal@inheritx.com
  /// Pass: 123456

  bool showLoading = false;

  bool showPassword = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return BaseScaffold(
      showToolbar: false,
      isScreenLoadingWithBackground: showLoading,
//      scaffoldBackgroundColor: AppConstants.PRIMARY_COLOR,
      scaffoldBackgroundColor: themeData.primaryColor,
      body: loginBody(),
    );
  }

  Widget loginBody() {
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
              CommonUtils.getText(context, AppTranslate.LOG_IN),
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
            textFieldEmail(),
            SizedBox(height: SizeUtils.get(10)),
            textFieldPassword(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(8)),
            ButtonUtils.btnFillWhite(
                CommonUtils.getText(context, AppTranslate.LOG_IN),
                () => this.btnLoginClick()),
            SizedBox(height: SizeUtils.get(20)),
            forgotPassword(),
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
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) => InputValidator.validateEmail(context, value),
        onSaved: (value) => _email = value,
        keyboardType: TextInputType.emailAddress);
  }

  Widget textFieldPassword() {
    return InputTextFieldUtils.inputTextField(
        label: CommonUtils.getText(context, AppTranslate.ENTER_PASSWORD),
        focusNode: _passwordFocusNode,
        onFieldSubmitted: (value) {
          btnLoginClick();
        },
        validator: (value) => InputValidator.validatePassword(context, value),
        onSaved: (String value) {
          _password = value;
        },
        isTextInputActionDone: true,
        isObscureText: !showPassword,
        isPasswordType: true,
        onTapVisiblePassword: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        keyboardType: TextInputType.text);
  }

  Widget forgotPassword() {
    return GestureDetector(
      onTap: () {
        navigationPageToForgotPassword();
      },
      child: Text(
        CommonUtils.getText(context, AppTranslate.FORGOT_PASSWORD),
        style: themeData.textTheme.button.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
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
//      Navigator.pushReplacement(
//          context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void navigationPageToForgotPassword() {
    Navigator.push(context, CommonUtils.createRoute(ForgotPasswordPage()));
  }

  void _handleSignIn() async {
    String errorMessage = '';

    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

//      UserUpdateInfo profile = UserUpdateInfo();
//      profile.displayName = _userName;
//      profile.photoUrl = '';
//      result.user.updateProfile(profile);

      print("Pinkal uid             :: ${result.user.uid}");
      print("Pinkal displayName     :: ${result.user.displayName}");
      print("Pinkal isEmailVerified :: ${result.user.isEmailVerified}");
      print("Pinkal email           :: ${result.user.email}");
      print("Pinkal photoUrl        :: ${result.user.photoUrl}");
      print("Pinkal phoneNumber     :: ${result.user.phoneNumber}");

//      result.user.uid;

      FirebaseUser firebaseUser = await _auth.currentUser();
      firestoreInstance.collection("Users").document(firebaseUser.uid).setData({
        "username": firebaseUser.displayName,
        "isEmailVerified": firebaseUser.isEmailVerified,
        "email": firebaseUser.email,
        "photoUrl": firebaseUser.photoUrl,
        "phoneNumber": firebaseUser.phoneNumber,
      }, merge: true).then((_) {
        print("success!");
      });

      firestoreInstance
          .collection("Passcode")
          .document(firebaseUser.uid)
          .setData({
        "passcode": "",
        "uid": firebaseUser.uid,
      }, merge: true).then((_) {
        print("success!");
      });

      setLoadingState(false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage =
              CommonUtils.getText(context, AppTranslate.FIREBASE_INVALID_EMAIL);
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = CommonUtils.getText(
              context, AppTranslate.FIREBASE_INVALID_PASSWORD);
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
