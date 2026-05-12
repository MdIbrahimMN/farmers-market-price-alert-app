import 'package:flutter/material.dart';
import '../models/price_model.dart';
import '../services/firestore_service.dart';

class PriceProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<Price> _prices = [];

  List<Price> get prices => _prices;

  // Fetch data from Firestore
  void fetchPrices() {
    _service.getPrices().listen((snapshot) {
      _prices = snapshot.docs.map((doc) {
        return Price.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      notifyListeners();
    });
  }
}