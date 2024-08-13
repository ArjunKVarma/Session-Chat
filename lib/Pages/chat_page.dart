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
    final Map reciverId = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.exit_to_app))
        ],
        title: GestureDetector(
          onLongPress: () {
            Navigator.pushReplacementNamed(context, "/");
          },
          child: const Text("SessionChat"),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildmessages(reciverId)),
          ChatInput(
            recieverId: reciverId['reciverId'],
          )
        ],
      ),
    );
  }

  Widget _buildmessages(Map reciverId) {
    String senderId = _auth.currentUser!.uid;
    return StreamBuilder(
        stream: _chat.getMessages(reciverId['reciverId'], senderId),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Text("Error");
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
