// Light Theme Definition
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    primary: Colors.black,
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
    surface: Colors.white,
    shadow: Colors.black38,
  ),
);
