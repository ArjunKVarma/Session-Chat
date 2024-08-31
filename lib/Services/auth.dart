// Import the necessary package for working with Firebase Authentication
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define a class called AuthService to handle authentication-related tasks
class AuthService {
  // Create an instance of FirebaseAuth, which is the Firebase Authentication service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Define a method called signin to sign in a user with an email and password
  Future<UserCredential> signin(String email, String password) async {
    try {
      // Attempt to sign in the user with the provided email and password
      // using the signInWithEmailAndPassword method of FirebaseAuth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        // The email address of the user
        // Create a sample gmail for Firebase using input username
        email: ("$email@gmail.com").trim(),
        // The password of the user
        password: password,
      );
      
      // Return the UserCredential object, which contains information about the signed-in user
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Catch any FirebaseAuthException that may occur during the sign-in process
      // and throw an Exception with the error code

      throw Exception(e.code);
    }
  }

  // Define a method called signup to sign up a new user with an email and password
  Future<UserCredential?> signup(String email, String password) async {
    try {
      // Attempt to create a new user with the provided email and password
      // using the createUserWithEmailAndPassword method of FirebaseAuth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        // The email address of the new user
        // Create a sample gmail for Firebase using input username

        email: ("$email@gmail.com").trim(),
        // The password of the new user
        password: password,
      );

      //Add user to users collection
      // Get the newly created user's UID
      String uid = userCredential.user!.uid;

      // Create a new document in the "users" collection with the user's UID
      FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'username': email,
        'uid': uid,
      });
      // Return the UserCredential object, which contains information about the newly created user
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Catch any FirebaseAuthException that may occur during the sign-up process
      // and throw an Exception with the error code
      throw Exception(e.code);
    }
  }

  // Define a method called logout to sign out the current user
  Future<void> logout() async {
    // Attempt to sign out the current user using the signOut method of FirebaseAuth
    return await _auth.signOut();
  }
}
