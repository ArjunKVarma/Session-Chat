// Import the necessary package for building Flutter applications
import 'package:flutter/material.dart';

// Define a new stateless widget class named Imagedisplay
class Imagedisplay extends StatelessWidget {
  // Declare a final variable named src of type String
  // This variable will hold the source URL of the image to be displayed
  final String src;

  // Define a constructor for the Imagedisplay class
  // The constructor takes an optional key parameter and a required src parameter
  const Imagedisplay({super.key, required this.src});

  // Override the build method of the StatelessWidget class
  // This method is responsible for building the widget tree
  @override
  Widget build(BuildContext context) {
    // Return an Image widget that displays the image from the network
    // The Image.network constructor is used to create an Image widget that loads an image from a URL
    // The src variable is passed as the URL of the image to be loaded
    return Image.network(src);
  }
}
