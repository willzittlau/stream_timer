import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  // Set vars
  final String theme = "theme";
  final String screen = "screen";
  bool _isDarkMode;
  bool _hideScreen;
  SharedPreferences _pref;

  // Set getters
  bool get hideScreen => _hideScreen;
  bool get isDarkMode => _isDarkMode;

  // Set default constructor
  AppStateNotifier() {
    _isDarkMode = false;
    _hideScreen = false;
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

    Future<bool> getScreen() async {
    await _loadFromPrefs();
    return _hideScreen;
  }

}
