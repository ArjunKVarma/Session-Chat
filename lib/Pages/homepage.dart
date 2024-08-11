import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Services/log_check.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void logout() {
    final AuthService _auth = AuthService();
    _auth.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onLongPress: () {
            logout();
          },
          child: new Text("SessionChat"),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            color: Colors.white,
          ),
          Text("Connect ID"),
          ElevatedButton(onPressed: () {}, child: Text("Join")),
          Column()
        ],
      ),
    );
  }
}
