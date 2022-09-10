import 'package:dailyexpenses/data/local/language_manager.dart';
import 'package:dailyexpenses/data/local/theme_manager.dart';
import 'package:dailyexpenses/language/app_translations_delegate.dart';
import 'package:dailyexpenses/language/application.dart';
import 'package:dailyexpenses/ui/auth/splash_page.dart';
import 'package:dailyexpenses/utils/constants/app_constants.dart';
import 'package:dailyexpenses/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'app_theme/app_theme.dart';
import 'data/local/currency_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeHive();

  runApp(
//    MultiProvider(
//      providers: [
////        ChangeNotifierProvider(create: (_) => LanguageProvider()),
////          ChangeNotifierProvider(create: (_) => Animate()),
////          ChangeNotifierProvider(create: (_) => ColorProvider()),
//      ],
//      child: MyApp(),
//    ),
      MyApp());
}

_initializeHive() async {
  final appDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);

//  Hive.registerAdapter<Record>(RecordAdapter());
//  await Hive.openBox<Record>(boxRecord);

  await Hive.openBox(boxLanguage);
  final boxCurrencySettings = await Hive.openBox(boxCurrency);
  if (boxCurrencySettings.length == 0) {
    CurrencyManager().updatePrimaryCurrency("₹");
  }
  final boxThemeSettings = await Hive.openBox(boxTheme);
  if (boxThemeSettings.length == 0) {
    ThemeManager().updatePrimaryTheme(false);
  }
//  if (box.length == 0) {
//    print('Initialize Default Language Value');
//    box.put('primary_language', Locale('en').languageCode);
//  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  ThemeData currentTheme = MyAppTheme.lightTheme;

  @override
  void initState() {
    super.initState();
    setLanguage();
    setTheme();
  }

  Future setLanguage() async {
    final box = Hive.box(boxLanguage);
    if (box.length == 0) {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale('en'));
    } else {
      _newLocaleDelegate =
          AppTranslationsDelegate(newLocale: LanguageManager().primaryLanguage);
    }
    application.onLocaleChanged = onLocaleChange;
  }

  Future setTheme() async {
    onThemeChange(ThemeManager().primaryTheme);
    application.onThemeChange = onThemeChange;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.init(constraints, orientation);
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: MaterialApp(
              localizationsDelegates: [
                _newLocaleDelegate,
                // ... app-specific localization delegate[s] here
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''), // English
                const Locale('ar', ''), // Arabic
                const Locale('bn', ''), // Bengali
                const Locale('zh', ''), // Chinese
                const Locale('nl', ''), // Dutch
                const Locale('fr', ''), // French
                const Locale('de', ''), // German
                const Locale('el', ''), // Greek
                const Locale('gu', ''), // Gujarati
                const Locale('he', ''), // Hebrew
                const Locale('hi', ''), // Hindi
                const Locale('it', ''), // Italian
                const Locale('ja', ''), // Japanese
                const Locale('ko', ''), // Korean
                const Locale('ml', ''), // Malayalam
                const Locale('mr', ''), // Marathi
                const Locale('pa', ''), // Panjabi
                const Locale('pt', ''), // Portuguese
                const Locale('ro', ''), // Romanian
                const Locale('ru', ''), // Russian
                const Locale('es', ''), // Spanish
                const Locale('ta', ''), // Tamil
                const Locale('te', ''), // Telugu
                const Locale('th', ''), // Telugu
                const Locale('tr', ''), // Turkish
                const Locale('id', ''), // Indonesian
              ],
//                  localeResolutionCallback: (local, supportedLocals) {
//                    for (var supportLocal in supportedLocals) {
//                      if (supportLocal.languageCode == local.languageCode) {
////                          && supportLocal.countryCode == local.countryCode) {
//                        return supportLocal;
//                      }
//                    }
//                    return supportedLocals.first;
//                  },
//                  locale: _getCurrentLocale(context),
              debugShowCheckedModeBanner: false,
              title: AppConstants.APP_NAME,
              theme: currentTheme,
              home: SplashPage()),
        );
      });
    });
  }

  void onLocaleChange(Locale locale, {bool isSave = true}) {
    if (isSave) {
      LanguageManager().updatePrimaryLanguage(locale);
    }
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  void onThemeChange(bool isDarkTheme) {
    print("isDarkTheme :: $isDarkTheme");
    ThemeManager().updatePrimaryTheme(isDarkTheme);
    if (isDarkTheme) {
      setState(() {
        currentTheme = MyAppTheme.darkTheme;
      });
    } else {
      setState(() {
        currentTheme = MyAppTheme.lightTheme;
      });
    }
  }
}
