import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: const ColorScheme.light(
    surface: Color(0xfff6f6f6),
    primary: Color(0xffffffff),
    onSurface: Color(0xff282a29),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 32, 32, 32),
    primary:  Color.fromARGB(255, 224, 224, 224),
    onSurface: Color.fromARGB(255, 224, 224, 224), 
  ),
);