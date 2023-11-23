import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  fontFamily: 'Raleway',
  brightness: Brightness.light,
  primaryColor: Colors.indigo[700],
  backgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
      primary: Colors.indigo[700],
      seedColor: Colors.green,
      secondary: Colors.green,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
      outline: Colors.grey),
  textTheme: TextTheme(
    headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(
      fontSize: 16,
    ),
    subtitle1: TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
  ),
);

final darkTheme = ThemeData(
  fontFamily: 'Raleway',
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(1, 62, 71, 132),
  colorScheme: ColorScheme.fromSeed(
      primary: Color.fromARGB(1, 62, 71, 132),
      seedColor: Colors.green,
      secondary: Colors.deepPurple,
      surface: Colors.black,
      background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
      outline: Colors.grey),
  backgroundColor: Colors.black,
  textTheme: TextTheme(
    headline6: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
  ),
);
