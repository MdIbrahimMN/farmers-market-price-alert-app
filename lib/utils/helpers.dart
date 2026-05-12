import 'package:flutter/material.dart';

class Helpers {

  // Show Snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Format Price
  static String formatPrice(int price) {
    return "₹$price";
  }

  // Check High Price
  static bool isHighPrice(int price) {
    return price > 2500;
  }
}