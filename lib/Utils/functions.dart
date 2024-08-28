// Import the necessary package for Flutter development
import 'package:flutter/material.dart';

// Define a class called 'Functions' to encapsulate all the reusable functions
class Functions {
  /// Scrolls to the bottom of a scrollable widget using the provided ScrollController.

  /// @param _scrollController The ScrollController instance associated with the scrollable widget.
  void scrollToBottom(ScrollController _scrollController) {
    // Check if the ScrollController has clients (i.e., the scrollable widget has been built)
    if (_scrollController.hasClients) {
      // Animate the scroll to the maximum scroll extent (i.e., the bottom of the scrollable widget)
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        // Set the animation duration to 500 milliseconds
        duration: const Duration(milliseconds: 500),
        // Use the 'ease' curve for a smooth animation
        curve: Curves.ease,
      );
    }
  }

  /// Displays an auto-dismissing alert dialog with room data.
  ///
  /// @param context The BuildContext instance of the parent widget.
  /// @param roomId A Map containing the room ID.
  /// @param password A Map containing the password.
  void showAutoDismissAlert(BuildContext context, Map roomId, password) {
    // Show a dialog using the showDialog function
    showDialog(
      // Pass the parent widget's BuildContext instance
      context: context,
      // Define the dialog's builder function
      builder: (context) {
        // Return the AlertDialog widget
        return Container(
          // Center the dialog horizontally
          alignment: Alignment.topCenter,
          child: AlertDialog(
            // Set the dialog's shape to a rounded rectangle with a 5-pixel radius
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            // Set the dialog's title
            title: const Text("Room data"),
            // Define the dialog's content
            content: Column(
              // Set the column's main axis size to the minimum size
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display the room ID
                Row(
                  children: [
                    const Text("Room ID : "),
                    // Align the room ID text to the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("${roomId['room_id']}"),
                    ),
                  ],
                ),
                // Display the password
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password : ${password['password']}"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
