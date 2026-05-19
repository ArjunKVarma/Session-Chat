import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Frost & Glass Theme (Modern iOS-like dark mode)
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF38BDF8), // Bright Blue accent
    onPrimary: Colors.white,
    secondary: Color(0xFF818CF8), // Indigo/Purple accent
    onSecondary: Colors.white,
    surface: Color(0x1AFFFFFF), // Translucent white for glassmorphism (10% opacity)
    onSurface: Colors.white,
    error: Color(0xFFEF4444),
  ),
  scaffoldBackgroundColor: const Color(0xFF0F172A), // Very Dark Slate Background
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  useMaterial3: true,
);

// New White Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0284C7), // Darker Blue accent for contrast
    onPrimary: Colors.white,
    secondary: Color(0xFF4F46E5), // Indigo accent
    onSecondary: Colors.white,
    surface: Color(0x0D000000), // Translucent black for glassmorphism (5% opacity)
    onSurface: Color(0xFF1E293B), // Dark Slate Text
    error: Color(0xFFEF4444),
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Very Light Slate/White Background
  textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  useMaterial3: true,
);
