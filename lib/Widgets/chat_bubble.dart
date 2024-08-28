// Import the necessary packages
import 'package:flutter/material.dart';
// Import the Imagedisplay page from the sessionchat package
import 'package:sessionchat/Pages/Imagedisplay.dart';

// Define a stateless widget called ChatBubble
class ChatBubble extends StatelessWidget {
  // Declare a final string variable to hold the message
  final String message;
  // Declare a final Alignment variable to hold the alignment of the bubble
  final Alignment alignment;
  // Declare a final string variable to hold the type of the message (text or image)
  final String type;

  // Constructor for the ChatBubble widget
  const ChatBubble({
    // The key for the widget (optional)
    super.key,
    // The required alignment of the bubble
    required this.alignment,
    // The required message to be displayed
    required this.message,
    // The required type of the message (text or image)
    required this.type,
  });

  // Override the build method to define the UI of the widget
  @override
  Widget build(BuildContext context) {
    // Define a BorderRadius for the right side of the bubble
    BorderRadius right = const BorderRadius.only(
      // The bottom left corner of the bubble should be rounded with a radius of 10
      bottomLeft: Radius.circular(10),
      // The top left corner of the bubble should be rounded with a radius of 10
      topLeft: Radius.circular(10),
      // The top right corner of the bubble should be rounded with a radius of 10
      topRight: Radius.circular(10),
    );
    // Define a BorderRadius for the left side of the bubble
    BorderRadius left = const BorderRadius.only(
      // The bottom right corner of the bubble should be rounded with a radius of 10
      bottomRight: Radius.circular(10),
      // The top left corner of the bubble should be rounded with a radius of 10
      topLeft: Radius.circular(10),
      // The top right corner of the bubble should be rounded with a radius of 10
      topRight: Radius.circular(10),
    );
    // Return an Align widget to position the bubble
    return Align(
      // The alignment of the bubble (either Alignment.centerRight or Alignment.centerLeft)
      alignment: alignment,
      // The child of the Align widget
      child: Padding(
        // Add a padding of 8.0 around the bubble
        padding: const EdgeInsets.all(8.0),
        // The child of the Padding widget
        child: Container(
          // The decoration of the container (background color and border radius)
          decoration: BoxDecoration(
            // The background color of the bubble (white)
            color: const Color.fromARGB(255, 255, 255, 255),
            // The border radius of the bubble (either right or left depending on the alignment)
            borderRadius: (alignment == Alignment.centerRight) ? right : left,
          ),
          // The child of the Container widget
          child: Column(
            // The main axis size of the column should be minimized
            mainAxisSize: MainAxisSize.min,
            // The children of the Column widget
            children: [
              // Add a padding of 8.0 around the message
              Padding(
                padding: const EdgeInsets.all(8.0),
                // The child of the Padding widget
                child: (type == "text")
                    // If the type is "text", display a Text widget
                    ? Text(
                        // The message to be displayed
                        message,
                        // The style of the text (black color)
                        style: const TextStyle(color: Colors.black),
                      )
                    // If the type is not "text", display an image
                    : Stack(
                        // The children of the Stack widget
                        children: [
                          // Display a loading indicator while the image is loading
                          const SizedBox(
                            // The width and height of the loading indicator
                            width: 200,
                            height: 200,
                            // The child of the SizedBox widget
                            child: Center(
                              // The child of the Center widget
                              child:
                                  CircularProgressIndicator(), // loading indicator
                            ),
                          ),
                          // Display the image
                          SizedBox(
                            // The width and height of the image
                            width: 200,
                            height: 200,
                            // The child of the SizedBox widget
                            child: GestureDetector(
                              // The onTap callback for the image
                              onTap: () {
                                // Navigate to the Imagedisplay page when the image is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // The builder for the Imagedisplay page
                                    builder: (context) => Imagedisplay(
                                      // The source of the image
                                      src: message,
                                    ),
                                  ),
                                );
                              },
                              // The child of the GestureDetector widget
                              child: Image(
                                // The image to be displayed
                                image: NetworkImage(message),
                                // The fit of the image (cover the entire area)
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
