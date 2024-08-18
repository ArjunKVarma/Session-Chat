import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:sessionchat/Widgets/chat_bubble.dart';
import 'package:sessionchat/Widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chat = ChatService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map room_id = ModalRoute.of(context)!.settings.arguments as Map;
    final Map password = ModalRoute.of(context)!.settings.arguments as Map;
    print(room_id['room_id']);
    print(password['password']);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                const Text('Do you want to delete this chat?'),
                            content: const Text(
                                'This chat will be securly deleted from you device and our servers.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () async {
                                  await _chat.deleteChat(
                                      room_id['room_id'], password['password']);
                                  await _chat.removeRoom();
                                  Navigator.pushNamed(context, '/');
                                },
                              ),
                            ],
                          );
                        })
                  },
              icon: const Icon(Icons.exit_to_app))
        ],
        title: const Text("SessionChat"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("RoomId:  ${room_id['room_id']}"),
                Text("Password: ${password['password']}"),
              ],
            ),
          ),
          // ignore: prefer_interpolation_to_compose_strings

          Expanded(
              child: _buildmessages(room_id['room_id'], password['password'])),
          ChatInput(
            room_id: room_id['room_id'],
            password: password['password'],
          )
        ],
      ),
    );
  }

  Widget _buildmessages(String room_id, password) {
    String senderId = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _chat.getMessages(room_id, password),
        builder: (context, snap) {
          if (snap.hasError) {
            if (snap.error is Exception) {
              if (snap.error.toString() == "Chat room not found") {
                return Center(
                  child: Text(
                    "Chat room not found",
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                );
              } else {
                return Text(
                    "Error: ${snap.error.toString()}"); // <--- Changed here
              }
            } else {
              return Text(
                  "Error: ${snap.error.toString()}"); // <--- Changed here
            }
          }

          if (snap.connectionState == ConnectionState.waiting) {
            return const Text("Loading......");
          }

          return ListView(
            children: snap.data!.docs.map((doc) => _messageitem(doc)).toList(),
          );
        });
  }

  Widget _messageitem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String username = _auth.currentUser!.uid;
    print(data["message"]);

    return ChatBubble(
        alignment: data['senderId'] == username
            ? Alignment.centerRight
            : Alignment.centerLeft,
        message: data['message']);
  }
}
