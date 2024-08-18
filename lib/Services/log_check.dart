import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/homepage.dart';
import 'package:sessionchat/Pages/login_page.dart';
import 'package:sessionchat/Services/chat_service.dart';

class AuthVerify extends StatefulWidget {
  const AuthVerify({super.key});

  @override
  State<AuthVerify> createState() => _AuthVerifyState();
}

class _AuthVerifyState extends State<AuthVerify> {
  String? _roomId;
  final ChatService _chatService =
      ChatService(); // Create an instance of ChatService
  bool _isLoading = true; // Add this to track the loading state

  @override
  void initState() {
    super.initState();
    _initCurrRoom(); // Call a separate method to initialize currRoom
  }

  _initCurrRoom() async {
    _roomId =
        await _chatService.currRoom; // Access currRoom through the instance
    setState(() {
      _isLoading = false; // Set _isLoading to false when data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.hasData) {
            if (_roomId != null) {
              List<String> split = _roomId!.split("-");
              split.sort((a, b) => b.length
                  .compareTo(a.length)); // sort in descending order of length
              String noun = split[0];
              String password = split[1];
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/chat',
                    arguments: {"room_id": noun, "password": password});
              });
              return Container(); // Return an empty container to avoid building the widget tree again
            } else if (_isLoading) {
              return CircularProgressIndicator();
            }
            return Homepage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
