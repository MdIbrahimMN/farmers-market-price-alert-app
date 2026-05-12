import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  final String crop;
  final String mandi;
  final int price;

  const PriceCard({
    required this.crop,
    required this.mandi,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.agriculture, color: Colors.green),
        title: Text(crop),
        subtitle: Text(mandi),
        trailing: Text(
          "₹$price",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}