import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/data/local/language_manager.dart';
import 'package:dailyexpenses/ui/auth/select_language_page.dart';
import 'package:dailyexpenses/ui/auth/welcome_page.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/constants/color_constants.dart';
import 'package:dailyexpenses/utils/device_info.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';

import '../main_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //Common Variables
  ThemeData themeData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  @override
  void initState() {
    super.initState();
    versionCheck();
  }

  startTime() async {
    var _duration = Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(body: splashBody());
  }

  Widget splashBody() {
    return Container(
      padding: EdgeInsets.all(SizeUtils.get(50)),
      color: ColorConstants.APP_THEME_COLOR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                AppConstants.APP_NAME,
                style:
                    themeData.textTheme.display3.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigationPage() async {
    final box = await Hive.openBox(boxLanguage);
    if (box.length == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SelectLanguagePage()),
          (route) => false);
      return;
    }

    FirebaseUser user = await _auth.currentUser();
    print("user :: $user");

    if (user != null) {
      print("user displayName :: ${user.displayName}");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
          (route) => false);
    }
  }

  Future<void> versionCheck() async {
    await DeviceInfo.instance.initPlatformState();
    print("Device info :: ${DeviceInfo.instance.deviceData.toString()}");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String currentAppVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print("Package info :: "
        "\nappName : $appName"
        "\npackageName : $packageName"
        "\nversion : $currentAppVersion"
        "\n buildNumber : $buildNumber");

    if (Platform.isAndroid) {
      DocumentSnapshot snapshot = await firestoreInstance
          .collection("Version")
          .document('android')
          .get();
      String appVersion = snapshot.data['app_version'];
      bool forceUpdate = snapshot.data['force_update'];
      print("firebase app version :: $appVersion");

      bool isUpdateAvailable = false;

      List currentVersionList = currentAppVersion.split(".");
      List firebaseVersionList = appVersion.split(".");

      bool forward = false;
      for (int i = 0; i < currentVersionList.length; i++) {
        int cv = int.parse(currentVersionList[i].toString());
        int fv = int.parse(firebaseVersionList[i].toString());
        if (!forward) {
          if (cv < fv) {
            isUpdateAvailable = true;
            break;
          }
        }
        if (cv > fv) {
          forward = true;
        }
      }
      print("isUpdateAvailable :: $isUpdateAvailable");

      if (isUpdateAvailable) {
        if (forceUpdate) {
          Dialogs.showInfoDialog(context,
              "Application New version is available. Please update app to use the application.",
              buttonText: "Update", onPressed: () {
            OpenAppstore.launch(androidAppId: "com.avinashproduct.dailyexpenses");
          }, isCancelable: false);
        } else {
          Dialogs.showDialogWithTwoOptions(
              context,
              "Application new version is available. Please update app to use latest features.",
              "Update", positiveButtonCallBack: () {
            OpenAppstore.launch(androidAppId: "com.avinashproduct.dailyexpenses");
            Navigator.pop(context);
            startTime();
          }, onCancelClick: () {
            Navigator.pop(context);
            startTime();
          });
        }
      } else {
        startTime();
      }
    } else {
      startTime();
    }
  }
}
