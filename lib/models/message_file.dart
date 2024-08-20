// This is the class file where all details regarding a message entity are defined.

import 'package:cloud_firestore/cloud_firestore.dart';

// Define a class named Message to represent a message entity.
class Message {
  // Properties of the Message class:
  // - text: The content of the message.
  // - id: A unique identifier for the message.
  // - createdAt: The timestamp when the message was created.
  // - senderId: The ID of the user who sent the message.
  // - reciverId: The ID of the user who received the message.
  // - sendermail: The email address of the user who sent the message.
  String text;
  String id;
  Timestamp createdAt;
  String senderId;
  String reciverId;
  String sendermail;

  // Constructor for the Message class.
  // This constructor is used to create a new Message object with the given properties.
  Message({
    // The text property is required and must be provided when creating a new Message object.
    required this.text,
    // The id property is required and must be provided when creating a new Message object.
    required this.id,
    // The createdAt property is required and must be provided when creating a new Message object.
    required this.createdAt,
    // The reciverId property is required and must be provided when creating a new Message object.
    required this.reciverId,
    // The senderId property is required and must be provided when creating a new Message object.
    required this.senderId,
    // The sendermail property is required and must be provided when creating a new Message object.
    required this.sendermail,
  });

  // Method to convert the Message object to a Map.
  // This method is useful when you need to store the Message object in a database or send it over a network.
  Map<String, dynamic> toMap() {
    // Return a Map with the properties of the Message object.
    return {
      // The key 'message' is used to store the text property.
      'message': text,
      // The key 'id' is used to store the id property.
      'id': id,
      // The key 'senderId' is used to store the senderId property.
      'senderId': senderId,
      // The key 'createdAt' is used to store the createdAt property.
      'createdAt': createdAt,
      // The key 'reciverId' is used to store the reciverId property.
      'reciverId': reciverId,
      // The key 'sendermail' is used to store the sendermail property.
      'sendermail': sendermail,
    };
  }
}
