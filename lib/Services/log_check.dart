// Import necessary libraries
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/homepage.dart';
import 'package:sessionchat/Pages/login_page.dart';
import 'package:sessionchat/Services/chat_service.dart';

// Define a stateful widget to verify authentication
class AuthVerify extends StatefulWidget {
  const AuthVerify({super.key});

  @override
  State<AuthVerify> createState() => _AuthVerifyState();
}

// Define the state of the AuthVerify widget
class _AuthVerifyState extends State<AuthVerify> {
  // Initialize variables to store the room ID and show overlay
  String? _roomId;
  final ChatService _chatService = ChatService();
  bool _showOverlay = false;

  // Initialize the current room when the widget is created
  @override
  void initState() {
    super.initState();
    _initCurrRoom();
  }

  // Initialize the current room by calling the currRoom method of ChatService
  Future<void> _initCurrRoom() async {
    // Show the loading overlay while initializing the current room
    setState(() {
      _showOverlay = true;
    });
    try {
      // Get the current room ID from ChatService
      _roomId = await _chatService.currRoom;
    } finally {
      // Hide the loading overlay after 3 seconds
      setState(() {
        _showOverlay = false;
      });
    }
  }

  // Build the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Use a StreamBuilder to listen to authentication state changes
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              // If the user is authenticated, build the authenticated content
              if (snap.hasData) {
                return _buildAuthenticatedContent();
              } else {
                // Otherwise, return the login page
                return LoginPage();
              }
            },
          ),
          // Show the loading overlay if _showOverlay is true
          if (_showOverlay) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // Build the loading overlay widget
  Widget _buildLoadingOverlay() {
    return Container(
      // Set the color of the overlay to the surface color of the theme
      color: Theme.of(context).colorScheme.surface,
      child: const Center(
        // Show a circular progress indicator in the center of the overlay
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Build the content to display when the user is authenticated
  Widget _buildAuthenticatedContent() {
    // If the room ID is not null, build the chat room content
    if (_roomId != null) {
      return _buildChatRoomContent();
    } else {
      // Otherwise, return the homepage
      return const Homepage();
    }
  }

  // Build the chat room content widget
  Widget _buildChatRoomContent() {
    // Split the room ID into noun and password
    List<String> split = _roomId!.split("-");
    split.sort((a, b) => b.length.compareTo(a.length));
    String noun = split[0];
    String password = split[1];

    // Navigate to the chat room page with the noun and password as arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/chat',
          arguments: {"room_id": noun, "password": password});
    });

    // Return an empty container to avoid building the widget tree again
    return Container();
  }
}
