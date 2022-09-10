import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailyexpenses/custom_widget/background_widget.dart';
import 'package:dailyexpenses/custom_widget/dialogs.dart';
import 'package:dailyexpenses/custom_widget/image_view.dart';
import 'package:dailyexpenses/custom_widget/web_view_page.dart';
import 'package:dailyexpenses/data/local/currency_manager.dart';
import 'package:dailyexpenses/data/local/language_manager.dart';
import 'package:dailyexpenses/data/local/theme_manager.dart';
import 'package:dailyexpenses/language/app_translations.dart';
import 'package:dailyexpenses/language/application.dart';
import 'file:///D:/Development/Live-Project%20Flutter/daily_expenses/lib/data/preferences/preference_manager.dart';
import 'package:dailyexpenses/ui/auth/welcome_page.dart';
import 'package:dailyexpenses/ui/settings/ProfileDialog.dart';
import 'package:dailyexpenses/ui/settings/SetPasscodeDialog.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/common_utils.dart';
import 'package:dailyexpenses/utils/constants/icon_constants.dart';
import 'package:dailyexpenses/utils/constants/image_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'FeedbackDialog.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedBarIndex = 1;

  ThemeData themeData;

  String userName = "";
  String profilePic = ImageConstants.BACKGROUND;

  List<String> themeList = [];

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
    languagesList[2]: languageCodesList[2],
    languagesList[3]: languageCodesList[3],
    languagesList[4]: languageCodesList[4],
    languagesList[5]: languageCodesList[5],
    languagesList[6]: languageCodesList[6],
    languagesList[7]: languageCodesList[7],
    languagesList[8]: languageCodesList[8],
    languagesList[9]: languageCodesList[9],
    languagesList[10]: languageCodesList[10],
    languagesList[11]: languageCodesList[11],
    languagesList[12]: languageCodesList[12],
    languagesList[13]: languageCodesList[13],
    languagesList[14]: languageCodesList[14],
    languagesList[15]: languageCodesList[15],
    languagesList[16]: languageCodesList[16],
    languagesList[17]: languageCodesList[17],
    languagesList[18]: languageCodesList[18],
    languagesList[19]: languageCodesList[19],
    languagesList[20]: languageCodesList[20],
    languagesList[21]: languageCodesList[21],
    languagesList[22]: languageCodesList[22],
    languagesList[23]: languageCodesList[23],
    languagesList[24]: languageCodesList[24],
    languagesList[25]: languageCodesList[25],
  };
  final Map<dynamic, dynamic> languagesCodeMap = {
    languageCodesList[0]: languagesList[0],
    languageCodesList[1]: languagesList[1],
    languageCodesList[2]: languagesList[2],
    languageCodesList[3]: languagesList[3],
    languageCodesList[4]: languagesList[4],
    languageCodesList[5]: languagesList[5],
    languageCodesList[6]: languagesList[6],
    languageCodesList[7]: languagesList[7],
    languageCodesList[8]: languagesList[8],
    languageCodesList[9]: languagesList[9],
    languageCodesList[10]: languagesList[10],
    languageCodesList[11]: languagesList[11],
    languageCodesList[12]: languagesList[12],
    languageCodesList[13]: languagesList[13],
    languageCodesList[14]: languagesList[14],
    languageCodesList[15]: languagesList[15],
    languageCodesList[16]: languagesList[16],
    languageCodesList[17]: languagesList[17],
    languageCodesList[18]: languagesList[18],
    languageCodesList[19]: languagesList[19],
    languageCodesList[20]: languagesList[20],
    languageCodesList[21]: languagesList[21],
    languageCodesList[22]: languagesList[22],
    languageCodesList[23]: languagesList[23],
    languageCodesList[24]: languagesList[24],
    languageCodesList[25]: languagesList[25],
  };

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore firestoreInstance = Firestore.instance;

  String currentLanguage = "";
  String currentTheme = "";
  String selectTheme = "";
  String selectCurrency = "";
  String selectLanguage = "";
  String theme = "";
  String language = "";
  String currency = "";

  List<String> currencyList = [];

  String currencyValue = "";

  bool isPasscodeSet = false;

  @override
  void initState() {
    super.initState();
    setData();
    setLanguage();
    getPasscodeStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeList = [
      CommonUtils.getText(context, AppTranslate.LIGHT),
      CommonUtils.getText(context, AppTranslate.DARK)
    ];
    setTheme();
    selectLanguage =
        CommonUtils.getText(context, AppTranslate.KEY_SELECT_LANGUAGE);
    selectTheme = CommonUtils.getText(context, AppTranslate.KEY_SELECT_THEME);
    selectCurrency =
        CommonUtils.getText(context, AppTranslate.KEY_SELECT_CURRENCY);
    language = CommonUtils.getText(context, AppTranslate.KEY_LANGUAGE);
    theme = CommonUtils.getText(context, AppTranslate.KEY_THEME);
    currency = CommonUtils.getText(context, AppTranslate.CURRENCY);

    currencyList = [
      CommonUtils.getText(context, AppTranslate.CURRENCY_DOLLAR) + "   \$",
      CommonUtils.getText(context, AppTranslate.CURRENCY_RUPEE) + "   ₹",
      CommonUtils.getText(context, AppTranslate.CURRENCY_POUND) + "   £",
      CommonUtils.getText(context, AppTranslate.CURRENCY_YEN) + "   ¥",
      CommonUtils.getText(context, AppTranslate.CURRENCY_EURO) + "   €",
      CommonUtils.getText(context, AppTranslate.CURRENCY_PESO) + "   ₱",
      CommonUtils.getText(context, AppTranslate.CURRENCY_WON) + "   ₩",
      CommonUtils.getText(context, AppTranslate.CURRENCY_TURKISH) + "   ₺",
    ];

    String currencySymbol = CurrencyManager().primaryCurrency;
    setState(() {
      currencyValue = currencyList
          .where((element) => element.contains(currencySymbol))
          .toList()[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: settingBody(),
    );
  }

  Widget settingBody() {
    return BackgroundWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          titleAndSettings(),
          profileWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeUtils.get(20)),
                  Stack(
                    children: <Widget>[
                      Container(
//                          color: Colors.redAccent,
                        child: Column(
                          children: <Widget>[
//                            settingsCell(
//                              title: '',
//                              value: isPasscodeSet
//                                  ? "Change passcode"
//                                  : "Set passcode",
//                              icon: isPasscodeSet
//                                  ? Icons.lock
//                                  : Icons.lock_outline,
//                              onTap: () {
//                                openSetPasscodeDialog();
//                              },
//                            ),
//                            SizedBox(height: SizeUtils.get(20)),
//                            Divider(
//                                height: 1, thickness: 1, color: Colors.black26),
                            settingsCell(
                              title: language,
                              value: currentLanguage,
                              icon: Icons.language,
                              onTap: () {
                                languageSelection();
                              },
                            ),
                            settingsCell(
                              title: theme,
                              value: currentTheme,
                              icon: Icons.brightness_4,
                              onTap: () {
                                themeSelection();
                              },
                            ),
                            settingsCell(
                              title: currency,
                              value: currencyValue,
                              icon: Icons.attach_money,
                              onTap: () {
                                currencySelection();
                              },
                            ),
                            SizedBox(height: SizeUtils.get(20)),
                            Divider(
                                height: 1, thickness: 1, color: Colors.black26),
                            settingsCell(
                              title: '',
                              value: CommonUtils.getText(
                                  context, AppTranslate.FEEDBACK),
                              icon: Icons.send,
                              onTap: () {
                                openFeedbackDialog();
                              },
                            ),
//                            settingsCell(
//                              title: CommonUtils.getText(
//                                  context, AppTranslate.DONATION_MESSAGE),
//                              value: CommonUtils.getText(
//                                  context, AppTranslate.DONATION),
//                              icon: Icons.attach_money,
//                              onTap: () {
//                                _launchDonationURL();
//                              },
//                            ),
//                            SizedBox(height: SizeUtils.get(20)),
//                            Divider(
//                                height: 1, thickness: 1, color: Colors.black26),
                            settingsCell(
                              title: '',
                              value: CommonUtils.getText(
                                  context, AppTranslate.RATE_US),
                              icon: Icons.star_half,
                              onTap: () {
                                OpenAppstore.launch(
                                    androidAppId: "com.avinashproduct.dailyexpenses");
                              },
                            ),
                            settingsCell(
                              title: '',
                              value: CommonUtils.getText(
                                  context, AppTranslate.INVITE_FRIENDS),
                              icon: Icons.group_add,
                              onTap: () async {
                                await FlutterShare.share(
                                    title: 'Invite friends',
                                    text:
                                        'Daily Expenses\n\nTry this applection to manage you financial balance with easy way. Give it a try. Download app now from below URL.',
                                    linkUrl:
                                        'https://play.google.com/store/apps/details?id=com.avinashproduct.dailyexpenses',
                                    chooserTitle: 'Share with');
                              },
                            ),
                            SizedBox(height: SizeUtils.get(20)),
                            Divider(
                                height: 1, thickness: 1, color: Colors.black26),
                            settingsCell(
                              title: "",
                              value: CommonUtils.getText(context,
                                  AppTranslate.TERMS_AND_POLICY_TEXT_4),
                              icon: Icons.assignment,
                              onTap: () async {
                                DocumentSnapshot snapshot =
                                    await firestoreInstance
                                        .collection("URL")
                                        .document('privacy')
                                        .get();
                                String url = snapshot.data['url'] ?? '';
                                navigateToWeb(
                                  CommonUtils.getText(context,
                                      AppTranslate.TERMS_AND_POLICY_TEXT_4),
                                  url,
                                );
                              },
                            ),
                            settingsCell(
                              title: "",
                              value: CommonUtils.getText(context,
                                  AppTranslate.TERMS_AND_POLICY_TEXT_2),
                              icon: Icons.description,
                              onTap: () async {
                                DocumentSnapshot snapshot =
                                    await firestoreInstance
                                        .collection("URL")
                                        .document('terms')
                                        .get();
                                String url = snapshot.data['url'] ?? '';
                                navigateToWeb(
                                  CommonUtils.getText(context,
                                      AppTranslate.TERMS_AND_POLICY_TEXT_2),
                                  url,
                                );
                              },
                            ),
                            SizedBox(height: SizeUtils.get(20))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
//          SizedBox(height: SizeUtils.get(20)),
          Container(
            color: themeData.primaryColor,
            padding: EdgeInsets.only(bottom: SizeUtils.get(20)),
            child: settingsCell(
              title: '',
              value: CommonUtils.getText(context, AppTranslate.LOGOUT),
              icon: Icons.exit_to_app,
              onTap: () {
                logout();
              },
            ),
          ),
//          SizedBox(height: SizeUtils.get(20)),
        ],
      ),
    );
  }

  Widget settingsCell({String title, String value, icon, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: SizeUtils.get(10)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(40)),
            child: Text(
              title,
              style: themeData.textTheme.caption,
              textAlign: TextAlign.end,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeUtils.get(15), vertical: SizeUtils.get(5)),
            decoration: BoxDecoration(
                color: themeData.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  )
                ]),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeUtils.get(20), vertical: SizeUtils.get(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    icon,
                    size: SizeUtils.get(30),
                    color: themeData.accentColor,
                  ),
//                  Text(value, style: themeData.textTheme.headline6.copyWith()),
                  Expanded(
                    child: AutoSizeText(
                      value,
                      style: themeData.textTheme.headline6.copyWith(),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container titleAndSettings() {
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
              AppTranslations.of(context).text(AppTranslate.SETTINGS),
              style:
                  themeData.textTheme.display1.copyWith(color: Colors.black12),
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }

  Widget profileWidget() {
    return GestureDetector(
      onTap: () {
        editProfileDialog();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.get(20)),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.get(15), vertical: SizeUtils.get(25)),
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
              color: themeData.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: AutoSizeText(
                        userName,
                        style: TextStyle(
                          color: themeData.accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeUtils.getFontSize(38),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: SizeUtils.get(70),
                    height: SizeUtils.get(70),
                    child: ClipRRect(
                      child: Container(
                        child: ImageView(
                          height: SizeUtils.get(70),
                          width: SizeUtils.get(70),
                          placeholder: IconConstants.PROFILE_PLACEHOLDER,
                          image: profilePic,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editProfileDialog() {
    BuildContext buildContext = context;

    showDialog(
        context: context,
        builder: (context) {
          return ProfileDialog(
            userName: userName,
            profilePic: profilePic,
            updateList: (url, updateUserName) async {
              profilePic = url;
              userName = updateUserName;
              setState(() {});
            },
          );
        });
  }

  void openFeedbackDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return FeedbackDialog(
            updateList: () async {
              setState(() {});
            },
          );
        });
  }

  void openSetPasscodeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SetPasscodeDialog(
              updateList: () async {
                getPasscodeStatus();
              },
              isChangePasscode: isPasscodeSet);
        });
  }

  void getPasscodeStatus() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    DocumentSnapshot documentSnapshot = await firestoreInstance
        .collection("Passcode")
        .document(firebaseUser.uid)
        .get();

    isPasscodeSet = false;
    PreferenceManager.instance.setPasscode(false);
    if (documentSnapshot.exists &&
        documentSnapshot.data.containsKey("passcode")) {
      if (documentSnapshot.data["passcode"] != "") {
        isPasscodeSet = true;
        PreferenceManager.instance.setPasscode(true);
      }
    }
    setState(() {});
  }

  _launchDonationURL() async {
    DocumentSnapshot snapshot =
        await firestoreInstance.collection("URL").document('donation').get();
    String url = snapshot.data['url'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Dialogs.showInfoDialog(context, "Something went wrong.");
      throw 'Could not launch $url';
    }
  }

  languageSelection() {
    Dialogs.bottomSheetDialog(
        context: context,
        title: selectLanguage,
        optionList: languagesList,
        onTap: (index) async {
          await application
              .onLocaleChanged(Locale(languagesMap[languagesList[index]]));
          setLanguage();
        });
  }

  themeSelection() {
    Dialogs.bottomSheetDialog(
        context: context,
        title: selectTheme,
        optionList: themeList,
        onTap: (index) async {
          await application.onThemeChange(index == 0 ? false : true);
//          setTheme();
        });
  }

  currencySelection() {
    Dialogs.bottomSheetDialog(
        context: context,
        title: selectCurrency,
        optionList: currencyList,
        onTap: (index) async {
          await application.onCurrencyChange(
              currencyList[index].substring(currencyList[index].length - 1));
          setState(() {
            currencyValue = currencyList[index];
          });
        });
  }

  void logout() {
    Dialogs.showDialogWithTwoOptions(
        context,
        CommonUtils.getText(context, AppTranslate.LOGOUT_MESSAGE),
        CommonUtils.getText(context, AppTranslate.YES),
        positiveButtonCallBack: () async {
      _auth.signOut().then((onValue) {
        print("Successfully signout");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WelcomePage()),
                (route) => false);
      }).catchError((onError) {
        print("onError :: $onError");
        print("onError code :: ${onError.code}");
        Dialogs.showInfoDialog(
            context, CommonUtils.getText(context, AppTranslate.INTERNET_ERROR));
      });
    });
  }

  Future<void> setData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      var user = await _auth.currentUser();
      print("setData displayName :: ${user.displayName}");
      print("setData photoUrl :: ${user.photoUrl}");

      setState(() {
        userName = user.displayName;
        profilePic = user.photoUrl;
      });
    } catch (error) {}
  }

  void setLanguage() {
    String languageCode = LanguageManager().primaryLanguage.languageCode;
    setState(() {
      currentLanguage = languagesCodeMap[languageCode];
    });
  }

  void setTheme() {
    bool isDarkTheme = ThemeManager().primaryTheme;
    setState(() {
      currentTheme = isDarkTheme
          ? CommonUtils.getText(context, AppTranslate.DARK)
          : CommonUtils.getText(context, AppTranslate.LIGHT);
    });
  }

  void navigateToWeb(String title, String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(title: title, url: url)));
  }
}
