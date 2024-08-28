import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Widgets/elevatedbutton.dart';
import 'package:sessionchat/Widgets/input_box.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signin(context) async {
    final auth = AuthService();
    try {
      await auth.signin(usernameController.text, passwordController.text);
      Navigator.pushReplacementNamed(context, '/home',
          arguments: usernameController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error: ${e.toString()}'),
            );
          });
    }
  }

  void validate(context) async {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      signin(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontFamily: '<Roboto>',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Login to your existing Account",
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/icon_nb.png'),
                    height: 300,
                  ),
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        InputBox(
                          controller: usernameController,
                          hintText: 'Enter username',
                          validator: (value) {
                            if (value != null && value.length < 3) {
                              return 'Username must contain at least 3 letters';
                            }
                            return null;
                          },
                        ),
                        InputBox(
                          controller: passwordController,
                          hintText: 'Enter Password',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomElevatedButton(
                    text: "Sign-In",
                    onPressed: () async {
                      validate(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text(
                            "Register Now! ",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
