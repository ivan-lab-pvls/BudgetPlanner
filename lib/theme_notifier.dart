import 'package:budget_planner/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark }

class ThemeProvider extends ChangeNotifier {
  SavePreference pre = SavePreference();
  ThemeData currentTheme = ThemeClass.lightTheme;
  ThemeType themeType = ThemeType.light;
  ThemeProvider() {
    setInitialTheme();
  }
  setInitialTheme() {
    ThemeData theme = ThemeClass.lightTheme;
    pre.getTheme().then((value) {
      if (value != "null") {
        theme =
            (value == "dark") ? ThemeClass.darkTheme : ThemeClass.lightTheme;
      }
      currentTheme = theme;
      themeType =
          (theme == ThemeClass.lightTheme) ? ThemeType.light : ThemeType.dark;
      notifyListeners();
    });
  }

  changeCurrentTheme() {
    if (currentTheme == ThemeClass.darkTheme) {
      themeType = ThemeType.light;
      currentTheme = ThemeClass.lightTheme;
    } else {
      themeType = ThemeType.dark;
      currentTheme = ThemeClass.darkTheme;
    }
    pre.setTheme(themeType.name);
    notifyListeners();
  }
}

class SavePreference {
  // to set the mode
  Future<void> setTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }

// to get the mode
  Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme').toString();
  }
}
