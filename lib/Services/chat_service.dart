import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sessionchat/models/message_file.dart';
import 'package:word_generator/word_generator.dart';

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

  Future<void> sendMessage(String recieverID, message) async {
    final user = _auth.currentUser!;
    final Timestamp time = Timestamp.now();

    final wordGenerator = WordGenerator();
    String noun = wordGenerator.randomSentence(3);

    print("woooooooooooooord" + noun.trim().toLowerCase().replaceAll(" ", ''));

    Message new_message = Message(
        text: message,
        id: "100",
        createdAt: time,
        ReciverId: recieverID,
        senderId: user.uid,
        sendermail: user.email!);
    List<String> roomid = [user.uid, recieverID];
    roomid.sort();
    print(new_message.toString());
    String chatRoom_ID = roomid.join('-');
    await _firestore
        .collection('ChatRooms')
        .doc(chatRoom_ID)
        .collection('messages')
        .add(new_message.toMap());
  }

  Stream<QuerySnapshot> getMessages(String recieverID, senderId) {
    List<String> roomid = [senderId, recieverID];
    roomid.sort();

    String chatRoom_ID = roomid.join('-');
    return _firestore
        .collection('ChatRooms')
        .doc(chatRoom_ID)
        .collection("messages")
        .orderBy('createdAt', descending: false)
        .snapshots();
  }
}
