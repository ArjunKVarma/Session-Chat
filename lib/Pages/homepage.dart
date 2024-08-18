import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:word_generator/word_generator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final wordGenerator = WordGenerator();
  final ChatService _chat = ChatService();
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
          child: const Text("SessionChat"),
        ),
      ),
      body: userlist(),
    );
  }

  Widget userlist() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: const Text(
                        "Join an Existing room",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Form(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _roomIdController,
                            validator: (value) {
                              if (value != null) {
                                return 'Enter valid Room name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'Enter roomId',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value != null) {
                                return 'Enter valid room password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'Enter Password',
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _chat.setRoom(
                              _roomIdController.text, _passwordController.text);
                          Navigator.pushNamed(context, '/chat', arguments: {
                            "room_id": _roomIdController.text,
                            'password': _passwordController.text
                          });
                        },
                        child: Text("Join"),
                        style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(),
                          foregroundColor: Colors.black,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                    child: Text(
                  "Create a room",
                  style: TextStyle(fontSize: 20),
                )),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(),
                            foregroundColor: Colors.black,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                          ),
                          onPressed: () {
                            setState(() async {
                              if (noun == '' && password == '') {
                                noun = wordGenerator.randomSentence(3);
                                password = wordGenerator.randomVerb();
                                _chat.createChat(noun, password);
                                await _chat.setRoom(noun, password);
                                Navigator.pushReplacementNamed(context, '/chat',
                                    arguments: {
                                      "room_id": noun,
                                      "password": password
                                    });
                              }
                            });
                          },
                          child: const Text("Create Room")),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
