import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Services/chat_service.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  void logout(context) {
    final AuthService _auth = AuthService();
    _auth.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  final ChatService _chat = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onLongPress: () {
            logout(context);
          },
          child: new Text("SessionChat"),
        ),
      ),
      body: userlist(),
    );
  }

  Widget userlist() {
    return StreamBuilder(
        stream: _chat.getUsersStream(),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Text("Error");
          }

          if (snap.connectionState == ConnectionState.waiting) {
            return const Text("Loading......");
          }

          return ListView(
            children: snap.data!
                .map<Widget>(
                  (data) => builduser(data, context),
                )
                .toList(),
          );
        });
  }

  builduser(Map<String, dynamic> data, BuildContext context) {
    return ListTile(
      title: Text(data['email']),
      onTap: () {
        Navigator.pushNamed(context, '/chat',
            arguments: {"reciverId": data['uid']});
      },
    );
  }
}
