// Import necessary libraries
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/homepage.dart';
import 'package:sessionchat/Pages/login_page.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:provider/provider.dart';

// Define a stateful widget to verify authentication
class AuthVerify extends StatelessWidget {
  const AuthVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasData) {
            return const Homepage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
