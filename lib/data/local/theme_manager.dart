import 'package:hive/hive.dart';

const String boxTheme = 'appTheme';

class ThemeManager {
  bool _primaryTheme;

  var box = Hive.box(boxTheme);

  bool get primaryTheme => box.get('primary_theme');

  updatePrimaryTheme(bool isDarkTheme) {
    _primaryTheme = isDarkTheme;
    final box = Hive.box(boxTheme);
    box.put('primary_theme', _primaryTheme);
//    notifyListeners();
  }
}
