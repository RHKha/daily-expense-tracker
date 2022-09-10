import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const String boxLanguage = 'appLanguage';

class LanguageManager {
  Locale _primary;

  var box = Hive.box(boxLanguage);

  Locale get primaryLanguage => Locale(box.get('primary_language'));

  updatePrimaryLanguage(Locale locale) {
    _primary = locale;
    final box = Hive.box(boxLanguage);
    box.put('primary_language', _primary.languageCode);
//    notifyListeners();
  }
}
