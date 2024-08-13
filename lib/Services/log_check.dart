import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/homepage.dart';
import 'package:sessionchat/Pages/login_page.dart';

class AuthVerify extends StatelessWidget {
  const AuthVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            if (snap.hasData) {
              return Homepage();
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
