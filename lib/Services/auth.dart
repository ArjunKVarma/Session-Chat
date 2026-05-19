// Import the necessary package for working with Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a class called AuthService to handle authentication-related tasks
class AuthService {
  // Create an instance of FirebaseAuth, which is the Firebase Authentication service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Define a method called signin to sign in a user with a username and password
  Future<UserCredential> signin(String username, String password) async {
    try {
      // Attempt to sign in the user with the provided username and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        // Create a sample gmail for Firebase using input username
        email: ("$username@gmail.com").trim(),
        // The password of the user
        password: password,
      );
      
      // Return the UserCredential object, which contains information about the signed-in user
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Define a method called signup to sign up a new user with a username and password
  Future<UserCredential?> signup(String username, String password) async {
    try {
      // Attempt to create a new user with the provided username and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        // Create a sample gmail for Firebase using input username
        email: ("$username@gmail.com").trim(),
        // The password of the new user
        password: password,
      );

      // Get the newly created user's UID
      String uid = userCredential.user!.uid;

      // Create a new document in the "users" collection with the user's UID
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'username': username,
        'uid': uid,
      });
      // Return the UserCredential object
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Define a method called logout to sign out the current user
  Future<void> logout() async {
    // Attempt to sign out the current user using the signOut method of FirebaseAuth
    return await _auth.signOut();
  }
}
