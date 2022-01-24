import 'package:flutter/material.dart';

ThemeData temaPrincipal() {
  return ThemeData(
    colorScheme: ColorScheme(
        primary: Colors.teal.shade900, //Color primario
        primaryVariant: Colors.teal.shade800,
        secondary: Colors.teal.shade200,
        secondaryVariant: Colors.teal.shade300,
        surface: Colors.transparent,
        background: Colors.blue,
        error: Colors.red.shade800,
        onPrimary: Colors.white, //Color de las letras de los widgets
        onSecondary: Colors.white, //Color de iconos del floating button
        onSurface: Colors.black,
        onBackground: const Color(0xFF880E4F),
        onError: Colors.red.shade800,
        brightness: Brightness.light),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFF004D40),
      shape: CircularNotchedRectangle(),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal.shade800,
    ),
    bottomAppBarColor: Colors.teal.shade900,
    iconTheme: const IconThemeData(
      color: Color(0xFF880E4F), //0xFF880E4F
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.pink.shade900),
      ),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.white,
      dialBackgroundColor: Colors.black26,
    ),
  );
}
