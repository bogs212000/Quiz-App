
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore fbStore = FirebaseFirestore.instance;
final String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;

