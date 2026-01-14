import 'package:flutter/material.dart';

// Dark Theme Definition

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    primary: Colors.white,
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
    surface: Colors.black,
    shadow: Colors.white38,
  ),
);
