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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onLongPress: () {
            logout(context);
          },
          child: Icon(Icons.menu),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Flexible(
            flex: 10,
            child: Container(
              child: Center(
                child: Text(
                  "SessionChat",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 15,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: DefaultTabController(
                length: 2,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: [
                              Tab(
                                text: "Join",
                              ),
                              Tab(text: "Create"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TabBarView(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await _chat.setRoom(
                                                  _roomIdController.text,
                                                  _passwordController.text);
                                              Navigator.pushNamed(
                                                  context, '/chat', arguments: {
                                                "room_id":
                                                    _roomIdController.text,
                                                'password':
                                                    _passwordController.text
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: Text("Join"),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              foregroundColor: Colors.black,
                                              shadowColor: Colors.transparent,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                              ),
                                              onPressed: () {
                                                setState(() async {
                                                  if (noun == '' &&
                                                      password == '') {
                                                    noun = wordGenerator
                                                        .randomSentence(3);
                                                    password = wordGenerator
                                                        .randomVerb();
                                                    _chat.createChat(
                                                        noun, password);
                                                    await _chat.setRoom(
                                                        noun, password);
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, '/chat',
                                                            arguments: {
                                                          "room_id": noun,
                                                          "password": password
                                                        });
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child:
                                                    const Text("Create Room"),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
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
