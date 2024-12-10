import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:quiz_app/auth/auth.wrapper.dart';
import 'package:quiz_app/fucntion/firebase.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  Future<void> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Login Successful',
        'Welcome back, $email!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      Get.offAll(() => AuthWrapper());
      print("User signed in successfully");
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      // You can handle specific errors here, for example:
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided.");
      }
      Get.snackbar(
        'Error', // Title
        '${e.code}', // Message
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        // Position of Snackbar
        backgroundColor: Colors.red,
        // Background color
        colorText: Colors.white,
        // Text color
        duration: Duration(seconds: 3),
        // Duration the snackbar will show
        icon: Icon(Icons.info,
            color: Colors.white), // Icon to show on the snackbar
      );
    } catch (e) {
      Get.snackbar(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        'Error',
        // Title
        'An unknown error occurred',
        // Message
        snackPosition: SnackPosition.BOTTOM,
        // Position of Snackbar
        backgroundColor: Colors.red,
        // Background color
        colorText: Colors.white,
        // Text color
        duration: Duration(seconds: 3),
        // Duration the snackbar will show
        icon: const Icon(Icons.info,
            color: Colors.white), // Icon to show on the snackbar
      );
      print("An unknown error occurred: $e");
    }
  }

  Future<void> signUp(String email, password, username, imageUrl) async {
    try {
      await fbStore.collection('users').doc(email).set({
        'role': 'user',
        'email': email,
        'username': username,
        'profile': imageUrl,
        'score': 0,
      });
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Get.snackbar(
        'Account has been created',
        'Welcome, $email!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      Get.offAll(() => AuthWrapper());
      print("User signed in successfully");
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      // You can handle specific errors here, for example:
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided.");
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => AuthWrapper());
  }

  Future<void> addQuestions(
      int level, no, String question, a, b, c, d, answer) async {
    String uid = Uuid().v4();
    String quid = Uuid().v1();
    await fbStore.collection('levels').doc(level.toString()).set({
      'level': level,
      'level_id': uid,
      'status': false,
    });
    await fbStore
        .collection('levels')
        .doc(level.toString())
        .collection('questions')
        .doc(quid)
        .set({
      'question': question,
      'answer': answer,
      'a': a,
      'b': b,
      'c': c,
      'd': d,
      'no': no,
    });
    Get.snackbar(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      'Success',
      // Title
      'Successfully added!',
      // Message
      snackPosition: SnackPosition.BOTTOM,
      // Position of Snackbar
      backgroundColor: Colors.green,
      // Background color
      colorText: Colors.white,
      // Text color
      duration: Duration(seconds: 3),
      // Duration the snackbar will show
      icon: const Icon(Icons.info,
          color: Colors
              .white), // Icon to show on the snackbar
    );
  }
}
