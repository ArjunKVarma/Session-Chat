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
        ReciverId: room_id,
        senderId: user.uid,
        sendermail: user.email!);

    await _firestore
        .collection('ChatRooms')
        .doc(id)
        .collection('messages')
        .add(new_message.toMap());
  }

  Stream<QuerySnapshot> getMessages(String room_id, password, senderId) async* {
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
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
    await _firestore.collection('ChatRooms').doc(id).delete();
  }

  void createChat(String room_id, password) async {
    List<String> ids = [room_id, password];
    ids.sort();
    String id = ids.join('-').trim().toLowerCase().replaceAll(" ", '');
    await _firestore.collection('ChatRooms').doc(id).set({});
  }
}
