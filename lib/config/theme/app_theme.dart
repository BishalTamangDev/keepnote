import 'package:flutter/material.dart';

class AppTheme {
  // light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    canvasColor: Colors.grey.shade50,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.orangeAccent,
      primary: Colors.orangeAccent,
      onPrimary: Colors.white,
      surface: Colors.white,
    ),

    // app bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.black,
    ),

    // outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.orangeAccent),
        ),
      ),
    ),

    // elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
    ),
  );

  // dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    canvasColor: Colors.black,
    primaryColor: Colors.orangeAccent,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.orangeAccent,
      primary: Colors.orangeAccent,
      onPrimary: Colors.white,
      surface: Color(0xFF272727),
    ),

    // outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        side: BorderSide(color: Colors.orangeAccent),
      ),
    ),

    // elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
