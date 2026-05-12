import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  final crop = TextEditingController();
  final mandi = TextEditingController();
  final price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: crop,
              decoration: InputDecoration(labelText: "Crop"),
            ),
            TextField(
              controller: mandi,
              decoration: InputDecoration(labelText: "Mandi"),
            ),
            TextField(
              controller: price,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Price Added")));
              },
              child: Text("Add Price"),
            )
          ],
        ),
      ),
    );
  }
}