// Importing necessary packages
import 'dart:convert';
import 'dart:io'; // For File type
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:sessionchat/models/message_file.dart'; // For custom MessageFile model
import 'package:uuid/uuid.dart'; // For generating unique IDs
import 'package:sessionchat/Services/encryption_service.dart'; // For E2E Encryption
import 'package:crypto/crypto.dart';

// Defining the ChatService class
class ChatService {
  // Initializing Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initializing Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Generate a secure, deterministic room ID from the name and password
  String _getRoomId(String roomId, String password) {
    List<String> ids = [roomId, password];
    ids.sort();
    String combined = ids.join('-').trim().toLowerCase().replaceAll(" ", '');
    // Hash the combined string so the password is never visible in Firestore
    return sha256.convert(utf8.encode(combined)).toString();
  }


  // Defining a method to get a stream of users from Firestore
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    // Accessing the "Users" collection in Firestore
    return _firestore.collection("Users").snapshots().map((snap) {
      // Mapping over the snapshot of documents in the "Users" collection
      return snap.docs.map((docs) {
        // Extracting the data from each document
        final user = docs.data();
        // Returning the user data as a Map<String, dynamic>
        return user;
        // Converting the mapped data to a List
      }).toList();
    });
  }

  // Defining a method to send a message to a chat room
  Future<void> sendMessage(
      String roomId,
      String password,
      String message,
      String type,
      {String? messageid,
      String? replyTo,
      String? replyText}) async {
    // Getting the current authenticated user
    final user = _auth.currentUser!;

    // Getting the current timestamp
    final Timestamp time = Timestamp.now();

    // Sorting the list of IDs to ensure consistency
    String id = _getRoomId(roomId, password);

    // Generating a unique message ID if none is provided
    final mesId =
        (messageid == null) ? const Uuid().v1().toString() : messageid;

    // Encrypting the message content
    final encryptedMessage = EncryptionService.encryptText(message, password);
    final encryptedReplyText = replyText != null 
        ? EncryptionService.encryptText(replyText, password) 
        : null;

    // Creating a new Message object with the provided data
    Message newMessage = Message(
        // The type of the message
        type: type,
        // The text of the message (encrypted)
        text: encryptedMessage,
        // The unique ID of the message
        id: mesId,
        // The timestamp of when the message was sent
        createdAt: time,
        // The ID of the chat room the message is being sent to
        reciverId: roomId,
        // The ID of the user sending the message
        senderId: user.uid,
        // The username of the user sending the message
        senderUsername: user.email!.split('@').first,
        // Reply info
        replyTo: replyTo,
        replyText: encryptedReplyText);

    // Using Firestore to set the new message in the 'messages' subcollection of the chat room document
    await _firestore
        .collection('ChatRooms') // Accessing the 'ChatRooms' collection
        .doc(id) // Accessing the chat room document with the generated ID
        .collection('messages') // Accessing the 'messages' subcollection
        .doc(
            mesId) // Accessing the message document with the generated message ID
        .set(newMessage.toMap()); // Setting the message data as a Map
  }

  // Defining a method to get a stream of messages from a chat room
  Stream<QuerySnapshot> getMessages(
      // The ID of the chat room to retrieve messages from
      String roomId,
      // The password for the chat room (not used for authentication, but for generating a unique ID)
      password) async* {
    // Sorting the list of IDs to ensure consistency
    String id = _getRoomId(roomId, password);

    // Getting a reference to the chat room document in Firestore
    final chatRoomRef = _firestore.collection('ChatRooms').doc(id);

    // Getting the chat room document from Firestore
    final chatRoomDoc = await chatRoomRef.get();

    // Checking if the chat room document exists
    if (chatRoomDoc.exists) {
      // If the chat room exists, yielding a stream of messages from the 'messages' subcollection
      yield* chatRoomRef
          .collection("messages") // Accessing the 'messages' subcollection
          .orderBy('createdAt',
              descending:
                  false) // Ordering the messages by creation time in ascending order
          .snapshots(); // Getting a stream of snapshots from the 'messages' subcollection
    } else {
      // If the chat room does not exist, throwing an exception
      throw Exception("Chat room not found");
    }
  }

  /// Delete a specific message from a chat room
  Future<void> deleteMessage(String roomId, String password, String messageId) async {
    String id = _getRoomId(roomId, password);

    await _firestore
        .collection('ChatRooms')
        .doc(id)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  /// Delete a chat room and all its associated messages
  Future<void> deleteChat(String roomId, String password) async {
    // This is created to store and access the id of chatRoom
    String id = _getRoomId(roomId, password);

    // Get a snapshot of the messages collection in the chat room
    final querySnapshot = await _firestore
        .collection('ChatRooms') // Collection of chat rooms
        .doc(id) // Document with the combined ID
        .collection('messages') // Collection of messages in the chat room
        .get(); // Get the snapshot of the messages collection

    // Iterate over each document in the messages collection and delete it
    await Future.forEach(querySnapshot.docs, (doc) async {
      await doc.reference.delete();
    });

    // Finally, delete the chat room document itself
    await _firestore.collection('ChatRooms').doc(id).delete();
  }

  Future<void> createChat(String roomId, String password) async {
    String id = _getRoomId(roomId, password);

    // Create a new document in the 'ChatRooms' collection with the combined ID
    // Set the admin field to the current user's UID
    await _firestore.collection('ChatRooms').doc(id).set({
      'admin': _auth.currentUser!.uid,
    });
  }

  Future<bool> isAdmin(String roomId, String password) async {
    String id = _getRoomId(roomId, password);

    final doc = await _firestore.collection('ChatRooms').doc(id).get();
    if (doc.exists && doc.data() != null && doc.data()!.containsKey('admin')) {
      return doc.get('admin') == _auth.currentUser!.uid;
    }
    // For legacy rooms without an admin, no one is considered admin.
    return false;
  }

  /// Get the current room ID of the currently authenticated user
  Future<String?> get currRoom async {
    // Get the current user object from the authentication service
    final user = _auth.currentUser!;

    // Get a reference to the user's document in the "Users" collection
    // The document ID is the user's unique ID (UID)
    final userDoc = await _firestore.collection("Users").doc(user.uid).get();

    // Check if the user document exists and has a non-null "room_id" field
    if (userDoc.exists && userDoc.get("room_id") != null) {
      // If the document exists and has a "room_id" field, return its value
      return userDoc.get("room_id");
    } else {
      // If the document does not exist or the "room_id" field is null, return null
      return null;
    }
  }

  /// Update the room ID of the currently authenticated user
  Future<void> setRoom(String roomId, String password) async {
    String id = _getRoomId(roomId, password);

    // Get a reference to the user's document in the "Users" collection
    // The document ID is the user's unique ID (UID)
    await _firestore
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        // Update the user's document with the new room ID
        // The "room_id" field will be updated with the combined ID created above
        .update({"room_id": id});
  }

  /// Remove the current room ID of the currently authenticated user
  Future<void> removeRoom() async {
    // Get the current user object from the authentication service
    final user = _auth.currentUser!;

    // Get a reference to the user's document in the "Users" collection
    // The document ID is the user's unique ID (UID)
    final userDocRef = _firestore.collection("Users").doc(user.uid);

    // Get the user's document from the database
    final userDoc = await userDocRef.get();

    // Check if the user document exists
    if (userDoc.exists) {
      // If the document exists, update the "room_id" field to delete its value
      // This will remove the room ID from the user's document
      await userDocRef.update({"room_id": FieldValue.delete()});
    } else {
      // If the document does not exist, do nothing
      // This could be the case if the user has not been created in the database yet
    }
  }

  /// Get an image from the device's gallery, compress it, and send as Base64
  Future<void> getImage(String roomId, String password) async {
    ImagePicker _picker = ImagePicker();

    // Pick image with aggressive compression to fit in Firestore (1MB limit)
    final imgFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20, // Lower quality for reliability
      maxWidth: 700,    // Smaller width
    );

    if (imgFile != null) {
      final bytes = await imgFile.readAsBytes();
      
      // Check size (650KB limit to be safe with Base64 + Encryption overhead)
      if (bytes.length > 650000) {
        print("Image still too large after compression");
        return;
      }

      final base64String = base64Encode(bytes);
      
      // Send as a single message (it will be encrypted inside sendMessage)
      await sendMessage(roomId, password, base64String, "image");
    }
  }

  /// Upload an audio file as Base64 (Note: limited to short clips due to 1MB limit)
  Future<void> uploadAudio(String roomId, String password, String filePath) async {
    final File audioFile = File(filePath);
    if (!audioFile.existsSync()) return;

    try {
      final bytes = await audioFile.readAsBytes();
      
      // Check if file is too large for Firestore (1MB limit)
      if (bytes.length > 700000) { // ~700KB limit to account for Base64 + Encryption overhead
        print("Audio file too large for database storage");
        return;
      }

      final base64String = base64Encode(bytes);
      await sendMessage(roomId, password, base64String, "audio");
    } catch (e) {
      print("Error processing audio: $e");
    } finally {
      // Clean up local file
      if (audioFile.existsSync()) audioFile.deleteSync();
    }
  }
}
