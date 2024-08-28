// Import the necessary package for building Flutter widgets
import 'package:flutter/material.dart';

// Define a stateless widget named InputBox
class InputBox extends StatelessWidget {
  // Define the properties of the InputBox widget
  //
  // - controller: a required property of type TextEditingController, which is used to control the text in the input box
  // - hintText: a required property of type String, which is used to display a hint to the user in the input box
  // - validator: an optional property of type String? Function(String?)?, which is used to validate the input text
  // - obscureText: an optional property of type bool?, which is used to obscure the input text (e.g. for password input)
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool? obscureText;

  // Constructor for the InputBox widget
  //
  // - controller and hintText are required parameters
  // - validator and obscureText are optional parameters with default values
  InputBox({
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
  });

  // Override the build method to define the layout of the InputBox widget
  @override
  Widget build(BuildContext context) {
    // Return a Padding widget with a padding of 8.0 on all sides
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // Child of the Padding widget is a TextFormField widget
      child: TextFormField(
        // Set the controller property of the TextFormField to the controller property of the InputBox
        controller: controller,
        // Set the validator property of the TextFormField to the validator property of the InputBox
        validator: validator,
        // Set the decoration property of the TextFormField to an InputDecoration widget
        decoration: InputDecoration(
          // Set the hintText property of the InputDecoration to the hintText property of the InputBox
          hintText: hintText,
        ),
        // Set the obscureText property of the TextFormField to the obscureText property of the InputBox
        obscureText:
            obscureText!, // Note: the ! operator is used to assert that obscureText is not null
      ),
    );
  }
}
