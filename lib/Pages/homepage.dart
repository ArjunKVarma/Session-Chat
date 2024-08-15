import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:word_generator/word_generator.dart';
import 'package:english_words/english_words.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final wordGenerator = WordGenerator();
  final ChatService _chat = ChatService();
  final TextEditingController _room_id_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  String noun = '';
  String password = '';
  void logout(context) {
    final AuthService _auth = AuthService();
    _auth.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();
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
            logout(context);
          },
          child: new Text("SessionChat"),
        ),
      ),
      body: userlist(),
    );
  }

  Widget userlist() {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: _room_id_controller,
          ),
          TextField(
            controller: _password_controller,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat', arguments: {
                  "room_id": _room_id_controller.text,
                  'password': _password_controller.text
                });
              },
              child: Text("Join")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  if (noun == '' && password == '') {
                    noun = wordGenerator.randomSentence(3);
                    password = wordGenerator.randomVerb();
                    print(noun + password);
                    _chat.createChat(noun, password);

                    Navigator.pushNamed(context, '/chat',
                        arguments: {"room_id": noun, "password": password});
                  }
                });
              },
              child: Text("Create Room")),
          Text(noun)
        ],
      ),
    );
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
