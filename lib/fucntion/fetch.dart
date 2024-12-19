import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/fucntion/app.model.dart';
import 'package:quiz_app/fucntion/user.model.dart';

import 'const.dart';

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

Future<int> getPlayerRank(setState) async {
  try {
    // Fetch all users and sort them by score in descending order
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: true)
        .get();

    // Get the list of documents (players)
    List<QueryDocumentSnapshot> users = querySnapshot.docs;

    // Iterate to find the player's rank
    for (int i = 0; i < users.length; i++) {
      if (users[i].id == FirebaseAuth.instance.currentUser!.email.toString()) {
        // Rank is index + 1 since ranks are 1-based
        print('rank : $i');
        setState((){
          rank = i + 1;
        });
        return i + 1;
      }
    }

    // If player email is not found
    throw Exception("Player not found in the leaderboard.");
  } catch (e) {
    print("Error getting player rank: $e");
    return -1; // Return -1 to indicate an error
  }
}


