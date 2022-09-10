import 'dart:ui';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  ///  "en", English
  ///  "ar", Arabic
  ///  "bn", Bengali
  ///  "zh", Chinese
  ///  "nl", Dutch
  ///  "fr", French
  ///  "de", German
  ///  "el", Greek
  ///  "gu", Gujarati
  ///  "he", Hebrew
  ///  "hi", Hindi
  ///  "it", Italian
  ///  "ja", Japanese
  ///  "ko", Korean
  ///  "ml", Malayalam
  ///  "mr", Marathi
  ///  "pa", Panjabi
  ///  "pt", Portuguese
  ///  "ro", Romanian
  ///  "ru", Russian
  ///  "es", Spanish
  ///  "ta", Tamil
  ///  "te", Telugu
  ///  "th", Thai
  ///  "tr", Turkish
  ///  "id", Indonesian

  final List<String> supportedLanguages = [
    "English",
    "عربى (Arabic)",
    "বাংলা (Bengali)",
    "中文 (Chinese)",
    "Nederlands (Dutch)",
    "Français (French)",
    "Deutsche (German)",
    "Ελληνικά (Greek)",
    "ગુજરાતી (Gujarati)",
    "עִברִית (Hebrew)",
    "हिन्दी (Hindi)",
    "Italiano (Italian)",
    "日本人 (Japanese)",
    "한국어 (Korean)",
    "മലയാളം (Malayalam)",
    "मराठी (Marathi)",
    "ਪੰਜਾਬੀ (Panjabi)",
    "Português (Portuguese)",
    "Română (Romanian)",
    "русский (Russian)",
    "Español (Spanish)",
    "தமிழ் (Tamil)",
    "తెలుగు (Telugu)",
    "ไทย (Thai)",
    "Türk (Turkish)",
    "bahasa Indonesia (Indonesian)",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "ar",
    "bn",
    "zh",
    "nl",
    "fr",
    "de",
    "el",
    "gu",
    "he",
    "hi",
    "it",
    "ja",
    "ko",
    "ml",
    "mr",
    "pa",
    "pt",
    "ro",
    "ru",
    "es",
    "ta",
    "te",
    "th",
    "tr",
    "id",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
  ThemeChangeCallback onThemeChange;
  CurrencyChangeCallback onCurrencyChange;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale, {bool isSave});
typedef void ThemeChangeCallback(bool isDarkTheme);
typedef void CurrencyChangeCallback(String currency);
