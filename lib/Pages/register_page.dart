import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Widgets/elevatedbutton.dart';
import 'package:sessionchat/Widgets/input_box.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasscontroller = TextEditingController();

  void signup(BuildContext context) async {
    final AuthService _auth = context.read<AuthService>();

    try {
      await _auth.signup(usernameController.text, passwordController.text);
      if (context.mounted) {
        Navigator.pushNamed(context, '/home', arguments: usernameController.text);
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
      signup(context);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmpasscontroller.dispose();
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
                          'Register',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Create a new account",
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
                          const SizedBox(height: 12),
                          InputBox(
                            controller: confirmpasscontroller,
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.lock_reset,
                            validator: (value) {
                              if (value != null &&
                                  value != passwordController.text) {
                                return 'Passwords must Match';
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                        ],
                      )),
                  const SizedBox(height: 32),
                  CustomElevatedButton(
                    text: "Create Account",
                    onPressed: () async {
                      validate(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Login",
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
