import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sessionchat/models/message_file.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snap) {
      return snap.docs.map((docs) {
        final user = docs.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String room_id, password, message) async {
    final user = _auth.currentUser!;
    final Timestamp time = Timestamp.now();
    List<String> ids = [room_id, password];
    ids.sort();
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');
    Message new_message = Message(
        text: message,
        id: "100",
        createdAt: time,
        reciverId: room_id,
        senderId: user.uid,
        sendermail: user.email!);

    await _firestore
        .collection('ChatRooms')
        .doc(id)
        .collection('messages')
        .add(new_message.toMap());
  }

  Stream<QuerySnapshot> getMessages(String room_id, password) async* {
    List<String> ids = [room_id, password];
    ids.sort();
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');

    final chatRoomRef = _firestore.collection('ChatRooms').doc(id);
    final chatRoomDoc = await chatRoomRef.get();

    if (chatRoomDoc.exists) {
      yield* chatRoomRef
          .collection("messages")
          .orderBy('createdAt', descending: false)
          .snapshots();
    } else {
      throw Exception("Chat room not found");
    }
  }

  Future<void> deleteChat(String room_id, password) async {
    List<String> ids = [room_id, password];
    ids.sort();
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');
    print(id);

    await _firestore
        .collection('ChatRooms')
        .doc(id)
        .collection('messages')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
    await _firestore.collection('ChatRooms').doc(id).delete();
  }

  void createChat(String room_id, password) async {
    List<String> ids = [room_id, password];
    ids.sort();
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');
    await _firestore.collection('ChatRooms').doc(id).set({});
  }

  //Get the room_id of currentUser
  Future<String?> get currRoom async {
    final user = _auth.currentUser!;
    final userDoc = await _firestore.collection("Users").doc(user.uid).get();
    if (userDoc.exists && userDoc.get("room_id") != null) {
      return userDoc.get("room_id");
    } else {
      return null;
    }
  }

  //Change the room_id of current user
  Future<void> setRoom(String room_id, password) async {
    List<String> ids = [room_id, password];
    ids.sort();
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');
    await _firestore
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .update({"room_id": id});
  }

  // Remove current Users RoomId
  Future<void> removeRoom() async {
    final user = _auth.currentUser!;
    final userDocRef = _firestore.collection("Users").doc(user.uid);
    final userDoc = await userDocRef.get();
    if (userDoc.exists) {
      await userDocRef.update({"room_id": FieldValue.delete()});
    } else {}
  }
}
