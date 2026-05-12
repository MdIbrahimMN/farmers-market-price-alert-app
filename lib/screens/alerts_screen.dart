import 'package:flutter/material.dart';
import '../services/alert_store.dart';

class AlertsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alerts = AlertStore.getAlerts();

    return Scaffold(
      appBar: AppBar(title: Text("Alerts")),

      body: alerts.isEmpty
          ? Center(child: Text("No alerts yet"))
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      Icon(Icons.notifications, color: Colors.green),
                  title: Text(alerts[index]),
                );
              },
            ),
    );
  }
}