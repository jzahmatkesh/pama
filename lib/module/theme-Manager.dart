import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme {
 Light, Dark
}

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
 return anyEnum.toString().split('.')[1];
}

final appThemeData = {
 AppTheme.Light : ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    bottomAppBarColor: Colors.grey[100],
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.grey[600], fontFamily: 'Lalezar', fontSize: 14.0),
    ),
    fontFamily: 'nazanin',
 ),
 AppTheme.Dark : ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    primaryColor: Color(0xFF294c60),
    accentColor: Colors.lightBlueAccent,
    scaffoldBackgroundColor: Colors.grey[800],
    bottomAppBarColor: Colors.grey[700],
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.white70, fontFamily: 'Lalezar', fontSize: 14.0)
    ),
    fontFamily: 'nazanin',
 ),
};

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;
  final _kThemePreference = "theme_preference";
  
  String _token = "";

  int menuitem = 0;
  int cmpid = 0;

  ThemeManager() {
   // We load theme at the start
    _loadTheme();
  }
 
  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appThemeData[AppTheme.Dark];
    }
    return _themeData;
  }

  setMenuItem(int i){
    menuitem = i;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("MenuItem", menuitem);
    });
    notifyListeners();
  }

 /// Sets theme and notifies listeners about change. 
  setTheme(AppTheme theme) async {
    _themeData = appThemeData[theme];
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_kThemePreference, AppTheme.values.indexOf(theme));
    });
    notifyListeners();
  }

  void _loadTheme() {
   SharedPreferences.getInstance().then((prefs) {
     int preferredTheme = prefs.getInt(_kThemePreference) ?? 0;
     _themeData = appThemeData[AppTheme.values[preferredTheme]];
     menuitem = prefs.getInt("MenuItem") ?? 0;
     // Once theme is loaded - notify listeners to update UI
     notifyListeners();
   });
 }

  setToken(String str){
    _token = str;
  }

  String get token{
    return _token ?? "";
  }

  setCompany(int i){
    cmpid = i;
    // notifyListeners();
  }
}