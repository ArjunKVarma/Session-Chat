// Importing necessary packages
import 'dart:io'; // For File type
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:sessionchat/models/message_file.dart'; // For custom MessageFile model
import 'package:uuid/uuid.dart'; // For generating unique IDs

// Defining the ChatService class
class ChatService {
  // Initializing Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initializing Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Declaring a variable to store the selected image file from gallery
  File? image;

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
      // The ID of the chat room to send the message to
      String roomId,
      // The password for the chat room (not used for authentication, but for generating a unique ID)
      password,
      // The text of the message to be sent
      message,
      // The type of the message (e.g. text, image, etc.)
      type,
      // An optional message ID, used to update an existing message
      String? messageid) async {
    // Getting the current authenticated user
    final user = _auth.currentUser!;

    // Getting the current timestamp
    final Timestamp time = Timestamp.now();

    // Creating a list of IDs to generate a unique chat room ID
    List<String> ids = [roomId, password];

    // Sorting the list of IDs to ensure consistency
    ids.sort();

    // Joining the sorted IDs with a hyphen, trimming, converting to lowercase, and removing spaces
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

    // Generating a unique message ID if none is provided
    final mesId =
        (messageid == null) ? const Uuid().v1().toString() : messageid;

    // Creating a new Message object with the provided data
    Message newMessage = Message(
        // The type of the message
        type: type,
        // The text of the message
        text: message,
        // The unique ID of the message
        id: mesId,
        // The timestamp of when the message was sent
        createdAt: time,
        // The ID of the chat room the message is being sent to
        reciverId: roomId,
        // The ID of the user sending the message
        senderId: user.uid,
        // The email of the user sending the message
        sendermail: user.email!);

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
    // Creating a list of IDs to generate a unique chat room ID
    List<String> ids = [roomId, password];

    // Sorting the list of IDs to ensure consistency
    ids.sort();

    // Joining the sorted IDs with a hyphen, trimming, converting to lowercase, and removing spaces
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

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

  /// Delete a chat room and all its associated messages and images
  Future<void> deleteChat(String roomId, String password) async {
    // Create a list of IDs to sort and combine into a single ID
    List<String> ids = [roomId, password];

    // Sort the list of IDs to ensure consistency in the combined ID
    ids.sort();

    // Combine the sorted IDs into a single string, separated by hyphens
    // Remove any leading or trailing whitespace, and convert to lowercase
    // Replace any spaces with empty strings to ensure a clean ID
    // This is created to store and access the id of chatRoom
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

    // Get a snapshot of the messages collection in the chat room
    final querySnapshot = await _firestore
        .collection('ChatRooms') // Collection of chat rooms
        .doc(id) // Document with the combined ID
        .collection('messages') // Collection of messages in the chat room
        .get(); // Get the snapshot of the messages collection

    // Iterate over each document in the messages collection
    await Future.forEach(querySnapshot.docs, (doc) async {
      // Check if the document represents an image message
      if (doc.get('type') == 'image' && doc.get('message') != "") {
        // Get a reference to the image storage location
        final storageRef =
            FirebaseStorage.instance.refFromURL(doc.get('message'));

        // Delete the image from storage
        await storageRef.delete();
      }

      // Delete the message document from the Firestore database
      await doc.reference.delete();
    });

    // Finally, delete the chat room document itself
    await _firestore.collection('ChatRooms').doc(id).delete();
  }

  /// Create a new chat room with the given room ID and password
  void createChat(String roomId, String password) async {
    // Create a list of IDs to sort and combine into a single ID
    List<String> ids = [roomId, password];

    // Sort the list of IDs to ensure consistency in the combined ID
    ids.sort();

    // Combine the sorted IDs into a single string, separated by hyphens
    // Remove any leading or trailing whitespace, and convert to lowercase
    // Replace any spaces with empty strings to ensure a clean ID
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

    // Create a new document in the 'ChatRooms' collection with the combined ID
    // The document will be initialized with an empty object ({})
    // This will effectively create a new chat room with the given ID and password
    await _firestore.collection('ChatRooms').doc(id).set({});
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
    // Create a list of IDs to sort and combine into a single ID
    // This list contains the room ID and password, which will be used to create a unique ID
    List<String> ids = [roomId, password];

    // Sort the list of IDs to ensure consistency in the combined ID
    // This is important to ensure that the same room ID and password always produce the same combined ID
    ids.sort();

    // Combine the sorted IDs into a single string, separated by hyphens
    // Remove any leading or trailing whitespace, and convert to lowercase
    // Replace any spaces with empty strings to ensure a clean ID
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

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

  /// Get an image from the device's gallery and upload it to the server
  Future<void> getImage(String roomId, String password) async {
    // Create an instance of the ImagePicker class
    // This class provides a way to pick images from the device's gallery or camera
    ImagePicker _picker = ImagePicker();

    // Use the ImagePicker to pick an image from the device's gallery
    // The `pickImage` method returns a `PickedFile` object, which contains the path to the selected image
    final imgFile = await _picker.pickImage(source: ImageSource.gallery);

    // Check if an image was selected
    if (imgFile != null) {
      // Create a `File` object from the selected image path
      // This `File` object can be used to upload the image to the server
      image = File(imgFile.path);

      // Call the `uploadFile` function to upload the selected image to the server
      // Pass the `roomId` and `password` parameters to the `uploadFile` function
      uploadFile(roomId, password);
    }
  }

  /// Upload a file to Firebase Storage and update the message with the image URL
  Future<void> uploadFile(String roomId, String password) async {
    // Check if an image has been selected
    if (image != null) {
      // Generate a unique file name using a UUID
      String fileName = const Uuid().v1();

      // Generate a unique message ID using a UUID
      String mesId = const Uuid().v1();

      // Send a message to the room with the image type and message ID
      await sendMessage(roomId, password, "", "image", mesId);

      // Create a reference to the Firebase Storage bucket
      final ref =
          FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

      // Upload the image file to Firebase Storage
      var fileUploadTask = await ref.putFile(image!).catchError((error) {
        // Catch any errors that occur during the upload process
        throw error;
      });

      // Get the download URL of the uploaded image
      String ImageUrl = await fileUploadTask.ref.getDownloadURL();

      // Update the message with the image URL
      await updateMessage(roomId, password, ImageUrl, mesId);
    }
  }

  /// Update a message in the Firestore database with the image URL
  Future<void> updateMessage(
      String roomId, String password, String imageUrl, String mesId) async {
    // Create a list of IDs to generate a unique document ID
    List<String> ids = [roomId, password];

    // Sort the list of IDs to ensure consistency
    ids.sort();

    // Join the sorted IDs with a hyphen and trim any whitespace
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

    // Get a reference to the Firestore database
    // Specifically, get a reference to the 'ChatRooms' collection
    // Then, get a reference to the document with the generated ID
    // Finally, get a reference to the 'messages' subcollection
    // and the document with the message ID
    await _firestore
        .collection('ChatRooms')
        .doc(id)
        .collection('messages')
        .doc(mesId)
        .update({'message': imageUrl});

    // Update the message document with the image URL
    // This will overwrite the existing message with the new image URL
  }
}
