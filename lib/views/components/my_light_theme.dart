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
      onPrimary: Colors.blue[700]!, // Darker blue shade for dark mode
      secondary: Colors.grey[400]!, // Lighter grey for secondary in dark mode
      onSecondary: Colors.grey[200]!, // Much lighter grey for contrast
      error: Colors.red[300]!, // Softer red for errors in dark mode
      onError: Colors.greenAccent, // Green accent color for errors
      surface: Colors.grey[850]!, // Darker surface color
      onSurface: Colors.white, // Light color for onSurface text
    ),
  );
}
