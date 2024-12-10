import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/fucntion/app.model.dart';
import 'package:quiz_app/fucntion/user.model.dart';

Future<AppData?> fetchAppData() async {
  try {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore
      DocumentSnapshot appDoc = await FirebaseFirestore.instance
          .collection('app')
          .doc('settings')
          .get();

      if (appDoc.exists) {
        Map<String, dynamic> data = appDoc.data() as Map<String, dynamic>;
        return AppData.fromMap(data);
      } else {
        print("User data does not exist in Firestore.");
      }
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }
  return null;
}

Future<UserModel?> fetchUserData() async {
  try {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        print("User data does not exist in Firestore.");
      }
    } else {
      print("No user is logged in.");
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }
  return null;
}

