import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Widgets/elevatedbutton.dart';
import 'package:sessionchat/Widgets/input_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signin(BuildContext context) async {
    final auth = context.read<AuthService>();
    try {
      await auth.signin(usernameController.text, passwordController.text);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home',
            arguments: usernameController.text);
      }
    } on Exception catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              title: Text(
                e.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            );
          },
        );
      }
    }
  }

  void validate(BuildContext context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      signin(context);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient Ornaments
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF818CF8).withOpacity(0.15),
              ),
            ),
          ),
          // Glass Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(color: Colors.transparent),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Login to your existing Account",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Image(
                      image: AssetImage('assets/images/icon_nb.png'),
                      height: 120,
                    ),
                  ),
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          InputBox(
                            controller: usernameController,
                            hintText: 'Enter username',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value != null && value.length < 3) {
                                return 'Username must contain at least 3 letters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          InputBox(
                            controller: passwordController,
                            hintText: 'Enter Password',
                            prefixIcon: Icons.lock_outline,
                            validator: (value) {
                              if (value != null && value.length < 5) {
                                return 'Password must contain 5 letters';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                        ],
                      )),
                  const SizedBox(height: 32),
                  CustomElevatedButton(
                    text: "Sign-In",
                    onPressed: () async {
                      validate(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
