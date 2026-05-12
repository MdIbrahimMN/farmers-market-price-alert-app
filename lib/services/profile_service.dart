import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final user = FirebaseAuth.instance.currentUser;

  Stream<DocumentSnapshot> getProfile() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .set(data, SetOptions(merge: true));
  }
}