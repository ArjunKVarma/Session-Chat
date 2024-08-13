import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  String id;
  Timestamp createdAt;
  String senderId;
  String ReciverId;

  String sendermail;

  Message(
      {required this.text,
      required this.id,
      required this.createdAt,
      required this.ReciverId,
      required this.senderId,
      required this.sendermail});

  Map<String, dynamic> toMap() {
    return {
      'message': text,
      'id': id,
      'senderId': senderId,
      'createdAt': createdAt,
      'reciverId': ReciverId,
      'sendermail': sendermail,
    };
  }
}
