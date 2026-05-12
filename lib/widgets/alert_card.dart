import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String message;

  const AlertCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.green),
        title: Text(message),
      ),
    );
  }
}