import 'package:base_scaffold/base_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/data/network/network_check.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:dailyexpenses/app_theme/button_theme.dart';
import 'package:dailyexpenses/app_theme/input_decoration_theme.dart';
import 'package:dailyexpenses/custom_widget/background_widget.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/custom_widget/rounded_background_widget.dart';
import 'package:dailyexpenses/custom_widget/web_view_page.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/input_validator.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:dailyexpenses/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Common Variables
  ThemeData themeData;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _userNameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  //SignUp Data
  String _email = "";
  String _userName = "";
  String _password = "";

  bool showLoading = false;

  bool showPassword = false;
  bool showConfirmPassword = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return BaseScaffold(
//      scaffoldBackgroundColor: AppConstants.PRIMARY_COLOR,
      scaffoldBackgroundColor: themeData.primaryColor,
      showToolbar: false,
      isScreenLoadingWithBackground: showLoading,
      body: signUpBody(),
    );
  }

  Widget signUpBody() {
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
              CommonUtils.getText(context, AppTranslate.CREATE_ACCOUNT),
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
            textFieldUserName(),
            SizedBox(height: SizeUtils.get(10)),
            textFieldEmail(),
            SizedBox(height: SizeUtils.get(10)),
            textFieldPassword(),
            SizedBox(height: SizeUtils.get(10)),
            textFieldConfirmPassword(),
            SizedBox(height: SizeUtils.getHeightAsPerPercent(8)),
            ButtonUtils.btnFillWhite(
                CommonUtils.getText(context, AppTranslate.CREATE_ACCOUNT),
                () => this.btnSignUpClick()),
            SizedBox(height: SizeUtils.get(10)),
          ],
        ),
      ),
    );
  }

  Widget textFieldUserName() {
    return InputTextFieldUtils.inputTextField(
        label: CommonUtils.getText(context, AppTranslate.ENTER_USER_NAME),
        focusNode: _userNameFocusNode,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        capsText: true,
        maxLength: 25,
        validator: (value) => InputValidator.validateUserName(context, value),
        onSaved: (value) => _userName = value,
        keyboardType: TextInputType.text);
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
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
        },
        validator: (value) => InputValidator.validatePassword(context, value),
        onSaved: (String value) {
          _password = value;
        },
        isObscureText: !showPassword,
        isPasswordType: true,
        onTapVisiblePassword: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
        keyboardType: TextInputType.text);
  }

  Widget textFieldConfirmPassword() {
    return InputTextFieldUtils.inputTextField(
        label:
            CommonUtils.getText(context, AppTranslate.ENTER_CONFIRM_PASSWORD),
        focusNode: _confirmPasswordFocusNode,
        onFieldSubmitted: (value) {
          btnSignUpClick();
        },
        validator: (value) {
          _formKey.currentState.save();
          return InputValidator.validateConfirmPassword(
              context, value, _password);
        },
        onSaved: (String value) {},
        isTextInputActionDone: true,
        isObscureText: !showConfirmPassword,
        isPasswordType: true,
        onTapVisiblePassword: () {
          setState(() {
            showConfirmPassword = !showConfirmPassword;
          });
        },
        keyboardType: TextInputType.text);
  }

  Future<void> btnSignUpClick() async {
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
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      UserUpdateInfo profile = UserUpdateInfo();
      profile.displayName = _userName;
      profile.photoUrl = '';
      result.user.updateProfile(profile);

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
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = CommonUtils.getText(
              context, AppTranslate.FIREBASE_ANONYMOUS_ACCOUNT);
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = CommonUtils.getText(
              context, AppTranslate.FIREBASE_PASSWORD_IS_WEAK);
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage =
              CommonUtils.getText(context, AppTranslate.FIREBASE_INVALID_EMAIL);
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = CommonUtils.getText(
              context, AppTranslate.FIREBASE_EMAIL_IS_ALREADY_USE);
          break;
        case "ERROR_INVALID_CREDENTIAL":
          errorMessage =
              CommonUtils.getText(context, AppTranslate.FIREBASE_INVALID_EMAIL);
          break;
        default:
          errorMessage = CommonUtils.getText(
                  context, AppTranslate.FIREBASE_UNKNOWN_ERROR) +
              " ${error.code}";
      }
      setLoadingState(false);
      Dialogs.showInfoDialog(context, errorMessage);

//    result.toString();
//      print("Pinkal :: " + result.toString());
//    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
//      email: _email,
//      password: _password,
//    ))
//        .user;
    }
  }

  void setLoadingState(bool isShow) {
    setState(() {
      this.showLoading = isShow;
    });
  }
}
