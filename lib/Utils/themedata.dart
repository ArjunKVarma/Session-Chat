// Import the necessary package for working with Flutter widgets
import 'package:flutter/material.dart';

// Define a ThemeData object to customize the visual styling of the app
ThemeData theme = ThemeData(
  // Define the color scheme of the app
  colorScheme: const ColorScheme.dark(
    // Define the primary color of the app (black)
    primary: Color.fromARGB(255, 0, 0, 0),
    // Define the surface color of the app (a light yellowish color with 140 alpha value)
    surface: Color.fromARGB(140, 249, 249, 164),
    // Define the color to use for secondary elements (black)
    onSecondary: Colors.black,
  ),
);
