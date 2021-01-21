import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  // Set vars
  final String theme = "theme";
  final String screen = "screen";
  final String clock = "clock";
  final String format = "format";
  bool _isDarkMode;
  bool _is24Hr;
  bool _hideScreen;
  bool _isClock;
  SharedPreferences _pref;

  // Set getters
  bool get hideScreen => _hideScreen;
  bool get is24Hr => _is24Hr;
  bool get isDarkMode => _isDarkMode;
  bool get isClock => _isClock;

  // Set default constructor
  AppStateNotifier() {
    _isDarkMode = false;
    _hideScreen = false;
    _isClock = false;
    _is24Hr = false;
    _loadFromPrefs();
  }

  // _initPref() is to iniliaze  the _pref variable
  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkMode = _pref.getBool(theme) ?? false;
    _hideScreen = _pref.getBool(screen) ?? false;
    _isClock = _pref.getBool(clock) ?? false;
    _is24Hr = _pref.getBool(format) ?? false;
    notifyListeners();
  }

  _saveThemeToPrefs() async {
    await _initPrefs();
    _pref.setBool(theme, _isDarkMode);
  }

  _saveScreenToPrefs() async {
    await _initPrefs();
    _pref.setBool(screen, _hideScreen);
  }

  _saveClockToPrefs() async {
    await _initPrefs();
    _pref.setBool(clock, _isClock);
  }

  _saveHourFormatToPrefs() async {
    await _initPrefs();
    _pref.setBool(format, _is24Hr);
  }

  void updateTheme(bool _isDarkMode) {
    this._isDarkMode = _isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void updateScreen() {
    _hideScreen = !this._hideScreen;
    _saveScreenToPrefs();
    notifyListeners();
  }

  void updateClock() {
    _isClock = !this._isClock;
    _saveClockToPrefs();
    notifyListeners();
  }

  void updateHourFormat() {
    _is24Hr = !this._is24Hr;
    _saveHourFormatToPrefs();
    notifyListeners();
  }

  Future<bool> getScreen() async {
    await _loadFromPrefs();
    return _hideScreen;
  }

  Future<bool> getClock() async {
    await _loadFromPrefs();
    return _isClock;
  }

  Future<bool> getHourFormat() async {
    await _loadFromPrefs();
    return _is24Hr;
  }
}
