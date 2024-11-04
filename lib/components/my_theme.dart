import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: const ColorScheme.light(
    surface: Color.fromARGB(255, 224, 224, 224),
    primary: Color.fromARGB(255, 66, 66, 66),
    secondary: Color.fromARGB(255, 66, 66, 66),
    onSurface: Color.fromARGB(255, 66, 66, 66),
  ),
  shadowColor: const Color.fromARGB(255, 117, 117, 117),
  highlightColor: const Color.fromARGB(255, 255, 255, 255),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 32, 32, 32),
    primary:  Color.fromARGB(255, 224, 224, 224),
    secondary: Color.fromARGB(255, 224, 224, 224),
    onSurface: Color.fromARGB(255, 224, 224, 224), 
  ),
  shadowColor: const Color.fromARGB(255, 0, 0, 0),
  highlightColor: const Color.fromARGB(255, 44, 44, 44),
);