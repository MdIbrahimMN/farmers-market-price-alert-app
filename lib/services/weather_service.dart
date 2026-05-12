import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // 🔑 Your API Key
  static const String apiKey = "b8f2350b1877c432fe8b8a9725d5cfdb";

  // 🌦️ GET WEATHER BASED ON CITY
  static Future<Map<String, dynamic>?> getWeather(String city) async {
    try {
      final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
      );

      final response = await http.get(url);

      // 🔍 Debug logs
      print("🌍 CITY: $city");
      print("🔥 STATUS CODE: ${response.statusCode}");
      print("🔥 RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ API ERROR: ${response.body}");
      }
    } catch (e) {
      print("❌ EXCEPTION: $e");
    }

    return null;
  }
}