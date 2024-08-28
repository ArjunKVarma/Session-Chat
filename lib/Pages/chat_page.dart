// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:sessionchat/Utils/functions.dart';
import 'package:sessionchat/Widgets/chat_bubble.dart';
import 'package:sessionchat/Widgets/chat_input.dart';

// Define the ChatPage widget
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// Define the _ChatPageState class
class _ChatPageState extends State<ChatPage> {
  // Initialize Firebase Authentication and ChatService instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chat = ChatService();

  // initialising Scrollccontroller for chatpage
  final ScrollController _scrollController = ScrollController();
  final Functions _functions = Functions();
  // Define the app title
  static const String _appTitle = "SessionChat";

  // Build the ChatPage widget
  @override
  Widget build(BuildContext context) {
    // Get the room ID and password from the route arguments
    final Map room_id = ModalRoute.of(context)!.settings.arguments as Map;
    final Map password = ModalRoute.of(context)!.settings.arguments as Map;

    // Return the Scaffold widget
    return Scaffold(
      // Set the background color to the primary color of the theme
      backgroundColor: Theme.of(context).colorScheme.primary,
      // Define the AppBar
      appBar: AppBar(
        // Hide the leading icon
        automaticallyImplyLeading: false,
        // Set the background color to transparent
        backgroundColor: Colors.transparent,
        // Define the actions
        actions: [
          // Add the delete chat button
          _deleteChatButton(room_id, password),
        ],
        // Set the title
        title: Row(
          children: [
            const Text(_appTitle),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () =>
                    _functions.showAutoDismissAlert(context, room_id, password),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      // Define the body
      body: Column(
        children: [
          // Add the message list
          Expanded(
              child: _messageList(room_id['room_id'], password['password'])),
          // Add the chat input
          ChatInput(
            room_id: room_id['room_id'],
            password: password['password'],
            ScollBottomCall: () {
              _functions.scrollToBottom(
                  _scrollController); // Call the scrollToBottom function
            },
          ),
        ],
      ),
    );
  }

  // Define the delete chat button
  Widget _deleteChatButton(Map room_id, Map password) {
    return IconButton(
      // Define the onPressed callback
      onPressed: () async {
        // Show a dialog to confirm deletion
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Do you want to delete this chat?'),
              content: const Text(
                  'This chat will be securely deleted from your device and our servers.'),
              actions: [
                // Add a cancel button
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    // Pop the dialog
                    Navigator.of(context).pop();
                  },
                ),
                // Add a confirm button
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () async {
                    // Delete the chat
                    await _chat.deleteChat(
                        room_id['room_id'], password['password']);
                    // Remove the room
                    await _chat.removeRoom();
                    // Navigate to the root route
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            );
          },
        );
      },
      // Set the icon
      icon: const Icon(Icons.delete_forever),
    );
  }

  // Define the message list
  Widget _messageList(String room_id, String password) {
    return StreamBuilder(
      // Get the messages stream
      stream: _chat.getMessages(room_id, password),
      builder: (context, snap) {
        // Check for errors
        if (snap.hasError) {
          return const Center(child: Text("This chat room doesn't exist"));
        }

        // Check for waiting state
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Return the ListView
        return ListView(
          controller: _scrollController,
          children: snap.data!.docs.map((doc) => _messageItem(doc)).toList(),
        );
      },
    );
  }

  // Define
  Widget _messageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String username = _auth.currentUser!.uid;

    return ChatBubble(
      alignment: data['senderId'] == username
          ? Alignment.centerRight
          : Alignment.centerLeft,
      message: data['message'],
      type: data['type'],
    );
  }
}
