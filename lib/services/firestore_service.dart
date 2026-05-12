import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add Farmer
  Future addFarmer(String name, String phone) async {
    await _db.collection('farmers').add({
      'name': name,
      'phone': phone,
      'createdAt': DateTime.now(),
    });
  }

  // Add Price (Admin)
  Future addPrice(String crop, String mandi, int price) async {
    await _db.collection('price').add({
      'crop': crop,
      'mandi': mandi,
      'price': price,
      'date': DateTime.now(),
    });
  }

  // Get Prices (Realtime)
  Stream<QuerySnapshot> getPrices() {
    return _db.collection('price').snapshots();
  }
}