import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn){
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes{
  static final lightTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    accentColor: Colors.black,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    hintColor: Colors.black54,
  );

  static final darkTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    accentColor: Colors.white,
    brightness: Brightness.dark,
    primaryColor: Color(0xff132097),
    backgroundColor: Color(0xff030e4c),
    hintColor: Colors.white60,
  );
}
