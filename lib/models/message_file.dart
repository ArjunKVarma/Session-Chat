// This is the class file where all details regarding a message entity are defined.

import 'package:cloud_firestore/cloud_firestore.dart';

// Define a class named Message to represent a message entity.
class Message {
  String text;
  String id;
  Timestamp createdAt;
  String senderId;
  String reciverId;
  String senderUsername;
  String type;
  String? replyTo;     // ID of the message being replied to
  String? replyText;   // Content of the message being replied to

  Message({
    required this.text,
    required this.id,
    required this.createdAt,
    required this.reciverId,
    required this.senderId,
    required this.senderUsername,
    required this.type,
    this.replyTo,
    this.replyText,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': text,
      'id': id,
      'senderId': senderId,
      'createdAt': createdAt,
      'reciverId': reciverId,
      'senderUsername': senderUsername,
      'type': type,
      'replyTo': replyTo,
      'replyText': replyText,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['message'],
      id: map['id'],
      createdAt: map['createdAt'],
      reciverId: map['reciverId'],
      senderId: map['senderId'],
      senderUsername: map['senderUsername'] ?? map['sendermail'] ?? 'Unknown',
      type: map['type'],
      replyTo: map['replyTo'],
      replyText: map['replyText'],
    );
  }
}
