import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.comfortable,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
  ),
  bottomAppBarColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.black,
    ),
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 15.0,
    ),
    headline4: TextStyle(
      color: Colors.black,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.comfortable,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white70,
    backgroundColor: Colors.black,
  ),
  bottomAppBarColor: Colors.black,
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.tealAccent,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.white,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    ),
    headline3: TextStyle(
      color: Colors.black,
      fontSize: 15.0,
    ),
    headline4: TextStyle(
      color: Colors.white,
    ),
  ),
);
