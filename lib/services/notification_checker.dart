import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class NotificationChecker {

  static Future checkAlerts() async {
    var users = await FirebaseFirestore.instance.collection('users').get();

    for (var user in users.docs) {

      var alerts = await user.reference.collection('alerts').get();
      var prices = await FirebaseFirestore.instance.collection('prices').get();

      for (var alert in alerts.docs) {
        var alertData = alert.data();

        for (var price in prices.docs) {
          var data = price.data();

          if (data['crop'] == alertData['crop'] &&
              data['price'] >= alertData['targetPrice']) {

            NotificationService.showNotification(
              "Price Alert 🔔",
              "${data['crop']} reached ₹${data['price']}",
              data['price'],
            );
          }
        }
      }
    }
  }
}