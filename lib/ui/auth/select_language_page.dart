import 'dart:ui';

import 'package:dailyexpenses/custom_widget/background_widget.dart';
import 'package:dailyexpenses/language/app_translations.dart';
import 'package:dailyexpenses/language/application.dart';
import 'package:dailyexpenses/ui/auth/welcome_page.dart';
import 'package:dailyexpenses/utils/app_translate.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:flutter/material.dart';

class SelectLanguagePage extends StatefulWidget {
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  ThemeData themeData;

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

  String currentLanguageCode = "en";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: selectLanguageBody(),
    );
  }

  Widget selectLanguageBody() {
    List<Widget> widgetList = [];

    for (int i = 0; i < languagesList.length; i++) {
      widgetList.add(settingsCell(
        title: '',
        value: languagesList[i],
        onTap: () {
          application.onLocaleChanged(Locale(languagesMap[languagesList[i]]),
              isSave: false);
          currentLanguageCode = languagesMap[languagesList[i]];
        },
      ));
    }
    widgetList.add(SizedBox(height: SizeUtils.get(20)));

    return BackgroundWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          titleWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widgetList,
              ),
            ),
          ),
          Container(
            color: Colors.lightGreen[400],
            padding: EdgeInsets.only(bottom: SizeUtils.get(20)),
            child: settingsCell(
              title: '',
              value:
                  AppTranslations.of(context).text(AppTranslate.KEY_CONTINUE),
              onTap: () {
                application.onLocaleChanged(Locale(currentLanguageCode));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                    (route) => false);
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
//                      color: Colors.grey[300],
                      blurRadius: 10,
                      offset: Offset(2, 3))
                ]),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeUtils.get(20), vertical: SizeUtils.get(15)),
              child: Text(
                value,
                style: themeData.textTheme.headline6.copyWith(
                  color: themeData.accentColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container titleWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.get(30), vertical: SizeUtils.get(20)),
      child: Text(
        AppTranslations.of(context).text(AppTranslate.KEY_SELECT_LANGUAGE),
        style: themeData.textTheme.display1.copyWith(color: Colors.black12),
        textAlign: TextAlign.end,
      ),
    );
  }
}
