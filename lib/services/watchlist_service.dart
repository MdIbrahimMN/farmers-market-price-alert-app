import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistService {
  final user = FirebaseAuth.instance.currentUser;

  CollectionReference get _watchlist => FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('watchlist');

  Future<void> addToWatchlist(Map<String, dynamic> data) async {
    await _watchlist.doc(data['crop']).set(data);
  }

  Future<void> removeFromWatchlist(String crop) async {
    await _watchlist.doc(crop).delete();
  }

  Stream<QuerySnapshot> getWatchlist() {
    return _watchlist.snapshots();
  }
}