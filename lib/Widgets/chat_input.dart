// Import the necessary packages for building Flutter widgets
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Import the ChatService class from the chat_service.dart file in the Services directory
import 'package:sessionchat/Services/chat_service.dart';

// Define a stateless widget named ChatInput
class ChatInput extends StatelessWidget {
  // Define the properties of the ChatInput widget
  //
  // - room_id: a required property of type String, which represents the ID of the chat room
  // - password: a required property of type String, which represents the password of the chat room
  // - chatMessageController: a TextEditingController instance, which is used to control the text in the chat input field
  // - _chat: an instance of the ChatService class, which is used to interact with the chat service
  // - ScollBottomCall: a required property of type VoidCallback, which is a callback function that is called when the user scrolls to the bottom of the chat
  final String room_id;
  final String password;
  final chatMessageController = TextEditingController();
  final ChatService _chat = ChatService();
  final VoidCallback ScollBottomCall;

  // Define a method named send that takes no parameters
  // This method is used to send a chat message to the chat room
  void send() async {
    // Call the sendMessage method on the ChatService instance
    //
    // - room_id: the ID of the chat room
    // - password: the password of the chat room
    // - chatMessageController.text: the text of the chat message
    // - "text": the type of the chat message (in this case, a text message)
    // - null: no additional data is sent with the chat message
    await _chat.sendMessage(
        room_id, password, chatMessageController.text, "text", null);
  }

  // Define a constructor for the ChatInput widget
  //
  // - key: an optional parameter of type Key?, which is used to identify the widget in the widget tree
  // - room_id: a required parameter of type String, which represents the ID of the chat room
  // - password: a required parameter of type String, which represents the password of the chat room
  // - ScollBottomCall: a required parameter of type VoidCallback, which is a callback function that is called when the user scrolls to the bottom of the chat
  ChatInput({
    Key? key,
    required this.room_id,
    required this.password,
    required this.ScollBottomCall,
  }) : super(key: key);

  // Override the build method to define the layout of the ChatInput widget
  @override
  Widget build(BuildContext context) {
    // Return a Container widget
    return Container(
      // Set the decoration property of the Container to a BoxDecoration instance
      decoration: BoxDecoration(
        // Set the color property of the BoxDecoration to the surface color of the current theme
        color: Theme.of(context).colorScheme.surface,
        // Set the border radius property of the BoxDecoration to a BorderRadius instance with a circular radius of 20.0 on the top left and top right corners
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // Set the height property of the Container to 100.0
      height: 100,
      // Set the child property of the Container to a Row widget
      child: Row(
        // Set the mainAxisAlignment property of the Row to MainAxisAlignment.spaceBetween
        // This will space the children of the Row evenly between the start and end of the Row
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Define the children of the Row
        children: [
          // Create an IconButton widget
          IconButton(
            // Set the onPressed property of the IconButton to a callback function that calls the getImage method on the ChatService instance
            onPressed: () async {
              await _chat.getImage(room_id, password);
            },
            // Set the icon property of the IconButton to a CupertinoIcons.paperclip icon
            icon: const Icon(CupertinoIcons.paperclip),
            // Set the color property of the IconButton to the onSecondary color of the current theme
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          // Create an Expanded widget to allow the TextField to take up the remaining space
          Expanded(
            // Create a TextField widget to allow the user to input text
            child: TextField(
              // Call the ScollBottomCall function when the TextField is tapped
              onTap: ScollBottomCall,

              // Set the controller of the TextField to the chatMessageController
              controller: chatMessageController,

              // Set the maximum number of lines to null, allowing the TextField to expand
              maxLines: null,

              // Set the keyboard type to TextInputType.multiline to allow multiple lines of text
              keyboardType: TextInputType.multiline,

              // Set the style of the text in the TextField
              style: TextStyle(
                // Set the color of the text to the onSecondary color of the current theme
                color: Theme.of(context).colorScheme.onSecondary,
              ),

              // Create an InputDecoration to customize the appearance of the TextField
              decoration: InputDecoration(
                // Set the hint text to "Message"
                hintText: "Message",

                // Remove the border of the TextField
                border: InputBorder.none,

                // Set the style of the hint text
                hintStyle: TextStyle(
                  // Set the color of the hint text to the onSecondary color of the current theme
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
          // Create an IconButton widget
          IconButton(
            // Set the onPressed property of the IconButton to a callback function
            onPressed: () {
              // Call the ScollBottomCall callback function to scroll to the bottom of the chat
              ScollBottomCall();
              // Check if the text in the chat input field is not empty
              if (chatMessageController.text.isNotEmpty) {
                // Call the send method to send the chat message
                send();
                // Clear the text in the chat input field
                chatMessageController.clear();
              }
            },
            // Set the icon property of the IconButton to an Icons.send_rounded icon
            icon: const Icon(Icons.send_rounded),
            // Set the color property of the IconButton to the onSecondary color of the current theme
            color: Theme.of(context).colorScheme.onSecondary,
          )
        ],
      ),
    );
  }
}
