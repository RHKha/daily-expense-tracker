import 'package:hive/hive.dart';

const String boxCurrency = 'appCurrency';

class CurrencyManager {
  String _primaryCurrency;

  var box = Hive.box(boxCurrency);

  String get primaryCurrency => box.get('primary_currency');

  updatePrimaryCurrency(String currency) {
    _primaryCurrency = currency;
    final box = Hive.box(boxCurrency);
    box.put('primary_currency', _primaryCurrency);
  }
}
