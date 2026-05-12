import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MandiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Government Agmarknet API
  Future<List<double>> fetchPrices() async {
    final url = Uri.parse(
      "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=YOUR_API_KEY&format=json&limit=7",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List records = data['records'];

      List<double> prices = records.map((e) {
        return double.tryParse(e['modal_price']) ?? 0;
      }).toList();

      return prices;
    } else {
      throw Exception("Failed to load mandi data");
    }
  }

  // ALL CROPS FROM FIREBASE
  Stream<QuerySnapshot> getAllPrices() {
    return _firestore.collection('price').snapshots();
  }

  // TOP 4 CROPS FOR DASHBOARD
  Stream<QuerySnapshot> getTopPrices() {
    return _firestore
        .collection('price')
        .orderBy('price', descending: true)
        .limit(4)
        .snapshots();
  }

  // GRAPH DATA
  Stream<QuerySnapshot> getTrendPrices() {
    return _firestore
        .collection('price')
        .orderBy('price')
        .limit(7)
        .snapshots();
  }

  // ALERTS COLLECTION
  Stream<QuerySnapshot> getAlerts() {
    return _firestore.collection('alerts').snapshots();
  }
}