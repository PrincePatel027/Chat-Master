import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLightTheme {
  static ThemeData lightTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.blue[300]!,
      secondary: Colors.grey[500]!,
      onSecondary: Colors.grey[800]!,
      error: Colors.red[400]!,
      onError: Colors.green,
      surface: Colors.grey[200]!,
      onSurface: Colors.grey[800]!,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.blue[300]!,
      secondary: Colors.grey[300]!,
      onSecondary: Colors.grey[600]!,
      error: Colors.red[400]!,
      onError: Colors.green,
      surface: Colors.grey[800]!,
      onSurface: Colors.grey[200]!,
    ),
  );
}
