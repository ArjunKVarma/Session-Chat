import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Services/chat_service.dart';
import 'package:sessionchat/Utils/functions.dart';
import 'package:sessionchat/Widgets/chat_bubble.dart';
import 'package:sessionchat/Widgets/chat_input.dart';
import 'package:provider/provider.dart';
import 'package:sessionchat/Services/encryption_service.dart'; // For decrypting messages

// Define the ChatPage widget
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// Define the _ChatPageState class
class _ChatPageState extends State<ChatPage> {
  // Initialize Firebase Authentication instances
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // initialising Scrollccontroller for chatpage
  final ScrollController _scrollController = ScrollController();
  final Functions _functions = Functions();
  final GlobalKey<ChatInputState> _inputKey = GlobalKey<ChatInputState>();
  // Define the app title
  static const String _appTitle = "SessionChat";

  // Build the ChatPage widget
  @override
  Widget build(BuildContext context) {
    // Get the room ID and password from the route arguments safely
    final args = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {};
    final String room_id = args['room_id'] ?? "";
    final String password = args['password'] ?? "";

    if (room_id.isEmpty) {
      return const Scaffold(body: Center(child: Text("Error: No room specified")));
    }

    // Return the Scaffold widget
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Define the AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        actions: [
          FutureBuilder<bool>(
            future: context.read<ChatService>().isAdmin(room_id, password),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                );
              }
              final bool isAdmin = snapshot.data ?? false;
              if (isAdmin) {
                return _deleteChatButton(room_id, password);
              } else {
                return _leaveChatButton(room_id, password);
              }
            },
          ),
        ],
        // Set the title
        title: Row(
          children: [
            const Text(_appTitle, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  elevation: WidgetStateProperty.all(0),
                ),
                onPressed: () =>
                    _functions.showAutoDismissAlert(context, {"room_id": room_id}, {"password": password}),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      // Define the body
      body: Stack(
        children: [
          // Background Gradient Ornaments
          Positioned(
            top: 50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF818CF8).withOpacity(0.1),
              ),
            ),
          ),
          // Glass Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Column(
              children: [
                // Add the message list
                Expanded(
                    child: _messageList(room_id, password)),
                // Add the chat input
                ChatInput(
                  key: _inputKey,
                  room_id: room_id,
                  password: password,
                  scrollBottomCall: () {
                    _functions.scrollToBottom(_scrollController);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Define the delete chat button
  Widget _deleteChatButton(String room_id, String password) {
    return IconButton(
      // Define the onPressed callback
      onPressed: () async {
        // Show a dialog to confirm deletion
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Do you want to delete this chat?'),
              content: const Text(
                  'This chat will be securely deleted from your device and our servers.'),
              actions: [
                // Add a cancel button
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    // Pop the dialog
                    Navigator.of(context).pop();
                  },
                ),
                // Add a confirm button
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () async {
                    // Get ChatService via Provider
                    final _chat = context.read<ChatService>();
                    // Delete the chat
                    await _chat.deleteChat(room_id, password);
                    // Remove the room
                    await _chat.removeRoom();
                    // Navigate to the root route
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      // Set the icon
      icon: const Icon(Icons.delete_forever),
    );
  }

  // Define the leave chat button for non-admins
  Widget _leaveChatButton(String room_id, String password) {
    return IconButton(
      onPressed: () async {
        // Show a dialog to confirm leaving
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Do you want to leave this chat?'),
              content: const Text(
                  'You will no longer be part of this chat room, but it will remain active for others.'),
              actions: [
                // Add a cancel button
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    // Pop the dialog
                    Navigator.of(context).pop();
                  },
                ),
                // Add a confirm button
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () async {
                    // Get ChatService via Provider
                    final _chat = context.read<ChatService>();
                    // Remove the room from the user's document
                    await _chat.removeRoom();
                    // Navigate to the root route
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      // Set the icon
      icon: const Icon(Icons.exit_to_app),
    );
  }

  // Define the message list
  Widget _messageList(String room_id, String password) {
    final _chat = context.read<ChatService>();
    return StreamBuilder(
      // Get the messages stream
      stream: _chat.getMessages(room_id, password),
      builder: (context, snap) {
        // Check for errors
        if (snap.hasError) {
          return const Center(child: Text("This chat room doesn't exist"));
        }

        // Check for waiting state
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Return the ListView
        return ListView(
          controller: _scrollController,
          children: snap.data!.docs.map((doc) => _messageItem(doc, password, room_id)).toList(),
        );
      },
    );
  }

  // Define
  Widget _messageItem(DocumentSnapshot doc, String password, String roomId) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String currentUserId = _auth.currentUser!.uid;

    // Decrypt the message or image URL before displaying
    String decryptedMessage = EncryptionService.decryptText(data['message'] ?? '', password);
    String? decryptedReplyText = data['replyText'] != null 
        ? EncryptionService.decryptText(data['replyText'], password) 
        : null;

    final timestamp = (data['createdAt'] as Timestamp).toDate();

    return ChatBubble(
      alignment: data['senderId'] == currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      message: decryptedMessage,
      type: data['type'],
      messageId: doc.id,
      senderUsername: data['senderUsername'] ?? 'Unknown',
      timestamp: timestamp,
      replyText: decryptedReplyText,
      onDelete: () {
        context.read<ChatService>().deleteMessage(roomId, password, doc.id);
      },
      onReply: () {
        // For replies, if it's an image/audio, we show a generic text
        String previewText = decryptedMessage;
        if (data['type'] == 'image') previewText = "📷 Image";
        if (data['type'] == 'audio') previewText = "🎤 Audio";
        
        _inputKey.currentState?.setReply(doc.id, previewText);
      },
    );
  }
}
