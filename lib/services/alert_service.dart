import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AlertService {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addAlert(String crop, int price, String mandi) async {
    final user = _authService.getCurrentUser();

    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('alerts')
          .add({
        'crop': crop,
        'targetPrice': price,
        'mandi': mandi,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Firestore error: $e");
    }
  }
}