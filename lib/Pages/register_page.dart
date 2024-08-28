import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Widgets/elevatedbutton.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasscontroller = TextEditingController();

  void signup(context) {
    final AuthService _auth = AuthService();

    try {
      _auth.signup(usernameController.text, passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error: ${e.toString()}'),
              ));
    }
  }

  void validate(context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      signup(context);
      Navigator.pushReplacementNamed(context, '/login',
          arguments: usernameController.text);
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
                        'Register',
                        style: TextStyle(
                            fontFamily: '<Roboto>',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Create a new account",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/icon_nb.png'),
                    height: 200,
                  ),
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value != null && value.length < 3) {
                                return 'Username must contain atleat 3 letters';
                              }
                              return null;
                            },
                            controller: usernameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter username',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value != null && value.length < 5) {
                                return 'Password must contain 5 letters';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter Password',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: confirmpasscontroller,
                            obscureText: true,
                            validator: (value) {
                              if (value != null &&
                                  value != passwordController.text) {
                                return 'Passwords must Match';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Confirm Password',
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomElevatedButton(
                    text: "Create Account",
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
                      const Text("Already Have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Login! ",
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
