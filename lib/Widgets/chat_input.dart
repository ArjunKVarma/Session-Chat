import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Services/chat_service.dart';

class ChatInput extends StatelessWidget {
  final String room_id;
  final String password;
  final chatMessageControllrer = TextEditingController();
  final ChatService _chat = ChatService();

  void send() async {
    await _chat.sendMessage(room_id, password, chatMessageControllrer.text);
  }

  ChatInput({Key? key, required this.room_id, required this.password})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container();
                    });
              },
              icon: const Icon(CupertinoIcons.paperclip)),
          Expanded(
              child: TextField(
                  controller: chatMessageControllrer,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "Message", border: InputBorder.none))),
          IconButton(
              onPressed: () {
                if (chatMessageControllrer.text.isNotEmpty) {
                  send();
                  chatMessageControllrer.clear();
                }
              },
              icon: const Icon(Icons.send_rounded))
        ],
      ),
    );
  }
}
