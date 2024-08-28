import 'package:flutter/material.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:sessionchat/Widgets/drawer_home.dart';
import 'package:sessionchat/Widgets/elevatedbutton.dart';
import 'package:sessionchat/Widgets/input_box.dart';
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const DrawerWidget(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          const Flexible(
            flex: 10,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/icon_nb.png'),
                    height: 100,
                  ),
                  Text(
                    "SessionChat",
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 15,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: DefaultTabController(
                length: 2,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: const TabBar(
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
                              Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Center(
                                        child: Text(
                                          "Join an Existing room",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        child: Column(
                                          children: [
                                            InputBox(
                                              controller: _roomIdController,
                                              hintText: 'Enter roomId',
                                              validator: (value) {
                                                if (value != null) {
                                                  return 'Enter valid Room name';
                                                }
                                                return null;
                                              },
                                            ),
                                            InputBox(
                                              controller: _passwordController,
                                              hintText: 'Enter Password',
                                              validator: (value) {
                                                if (value != null) {
                                                  return 'Enter valid room password';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomElevatedButton(
                                          text: "Join",
                                          onPressed: () async {
                                            joinRoom();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(
                                      child: Text(
                                    "Create a room",
                                    style: TextStyle(fontSize: 20),
                                  )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        CustomElevatedButton(
                                          text: "Create Room",
                                          onPressed: () async {
                                            createRoom();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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

  void createRoom() {
    setState(() async {
      if (noun == '' && password == '') {
        noun = wordGenerator.randomSentence(3);
        password = wordGenerator.randomVerb();
        _chat.createChat(noun, password);
        await _chat.setRoom(noun, password);
        Navigator.pushReplacementNamed(context, '/chat',
            arguments: {"room_id": noun, "password": password});
      }
    });
  }

  void joinRoom() async {
    await _chat.setRoom(_roomIdController.text, _passwordController.text);
    Navigator.pushNamed(context, '/chat', arguments: {
      "room_id": _roomIdController.text,
      'password': _passwordController.text
    });
  }
}
