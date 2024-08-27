import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/homepage.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatInput extends StatelessWidget {
  final String room_id;
  final String password;
  final chatMessageControllrer = TextEditingController();
  final ChatService _chat = ChatService();
  final VoidCallback ScollBottomCall;
  void send() async {
    await _chat.sendMessage(room_id, password, chatMessageControllrer.text);
  }

  ChatInput({
    Key? key,
    required this.room_id,
    required this.password,
    required this.ScollBottomCall,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text("s"),
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(CupertinoIcons.paperclip),
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          Expanded(
              child: TextField(
                  onTap: ScollBottomCall,
                  controller: chatMessageControllrer,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                  decoration: InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      )))),
          IconButton(
            onPressed: () {
              ScollBottomCall();
              if (chatMessageControllrer.text.isNotEmpty) {
                send();
                chatMessageControllrer.clear();
              }
            },
            icon: const Icon(Icons.send_rounded),
            color: Theme.of(context).colorScheme.onSecondary,
          )
        ],
      ),
    );
  }
}
