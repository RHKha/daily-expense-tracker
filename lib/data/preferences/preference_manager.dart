import 'dart:async';

import 'file:///D:/Development/Live-Project%20Flutter/daily_expenses/lib/data/preferences/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  //Singleton instance
  PreferenceManager._internal();

  static PreferenceManager instance = new PreferenceManager._internal();
  static SharedPreferences _prefs;

  factory PreferenceManager() {
    return instance;
  }

  Future<void> clearAll() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }

  // ------------------( IS LOGIN )------------------
  Future<bool> getIsLogin() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool(PreferenceConstants.IS_LOGIN);
  }

  Future<void> setIsLogin(bool isLogin) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(PreferenceConstants.IS_LOGIN, isLogin);
  }

  //DEVICE TOKEN
  Future<String> getDeviceToken() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.get(PreferenceConstants.DEVICE_TOKEN) ?? "";
  }

  Future<void> setDeviceToken(String deviceToken) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceConstants.DEVICE_TOKEN, deviceToken);
  }

  //AUTH TOKEN
  Future<String> getAuthToken() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.get(PreferenceConstants.AUTH_TOKEN) ?? "";
  }

  Future<void> setAuthToken(String authToken) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceConstants.AUTH_TOKEN, authToken);
  }

  Future<bool> isPasscodeSet() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.get(PreferenceConstants.PASSCODE_SET) ?? false;
  }

  Future<void> setPasscode(bool isPasscodeSet) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(PreferenceConstants.PASSCODE_SET, isPasscodeSet);
  }
}
