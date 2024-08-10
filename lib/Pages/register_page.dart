import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasscontroller = TextEditingController();

  void validate(context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      print(usernameController.text);
      print(passwordController.text);

      print('login successful!');
      Navigator.pushReplacementNamed(context, '/chat',
          arguments: usernameController.text);
    } else {
      print('not successful!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          margin: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontFamily: '<Roboto>',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Welcome back!",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      'https://my.alfred.edu/zoom/_images/foster-lake.jpg'),
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
                            decoration: InputDecoration(
                                hintText: 'Enter username',
                                border: OutlineInputBorder()),
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
                            decoration: InputDecoration(
                                hintText: 'Enter Password',
                                border: OutlineInputBorder()),
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
                            decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      validate(context);
                    },
                    child: Text("Sign-In"),
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(),
                      foregroundColor: Colors.black,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
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
