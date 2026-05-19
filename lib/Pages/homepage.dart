import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:provider/provider.dart';
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
  final _joinFormKey = GlobalKey<FormState>();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const DrawerWidget(),
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
          // Main Layout
          Column(
            children: [
              Flexible(
                flex: 10,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/icon_nb.png'),
                          height: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "SessionChat",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 15,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TabBar(
                                  dividerColor: Colors.transparent,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF38BDF8), Color(0xFF818CF8)],
                                    ),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.white54,
                                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                                  tabs: const [
                                    Tab(text: "Join"),
                                    Tab(text: "Create"),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: TabBarView(
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
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Form(
                                          key: _joinFormKey,
                                          child: Column(
                                            children: [
                                              InputBox(
                                                controller: _roomIdController,
                                                hintText: 'Enter Room ID',
                                                prefixIcon: Icons.door_front_door_outlined,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Enter valid Room name';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              InputBox(
                                                controller: _passwordController,
                                                hintText: 'Enter Password',
                                                prefixIcon: Icons.lock_outline,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Enter valid room password';
                                                  }
                                                  return null;
                                                },
                                                obscureText: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        CustomElevatedButton(
                                          text: "Join",
                                          onPressed: () async {
                                            joinRoom();
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Center(
                                            child: Text(
                                          "Create a secure room",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        )),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            CustomElevatedButton(
                                              text: "Generate & Create Room",
                                              onPressed: () async {
                                                createRoom();
                                              },
                                            ),
                                          ],
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
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void createRoom() async {
    if (noun != '' || password != '') return;

    final _chat = context.read<ChatService>();
    final generatedNoun = wordGenerator.randomSentence(3);
    final generatedPassword = wordGenerator.randomVerb();

    await _chat.createChat(generatedNoun, generatedPassword);
    await _chat.setRoom(generatedNoun, generatedPassword);

    if (!mounted) return;

    setState(() {
      noun = generatedNoun;
      password = generatedPassword;
    });

    Navigator.pushReplacementNamed(context, '/chat',
        arguments: {"room_id": generatedNoun, "password": generatedPassword});
  }

  void joinRoom() async {
    if (_joinFormKey.currentState != null && _joinFormKey.currentState!.validate()) {
      final _chat = context.read<ChatService>();
      await _chat.setRoom(_roomIdController.text.trim(), _passwordController.text.trim());
      
      if (mounted) {
        Navigator.pushNamed(context, '/chat', arguments: {
          "room_id": _roomIdController.text.trim(),
          'password': _passwordController.text.trim()
        });
      }
    }
  }
}
