import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {

  // ✅ YOUR CLOUD NAME
  static const String cloudName = "dh7cudt7p";

  // ✅ YOUR UNSIGNED PRESET
  static const String uploadPreset = "profile_upload";

  static Future<String?> uploadImage(Uint8List imageBytes) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var request = http.MultipartRequest("POST", url);

      // 🔥 REQUIRED FIELD
      request.fields['upload_preset'] = uploadPreset;

      // 🔥 FILE
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: "profile.jpg",
        ),
      );

      var response = await request.send();

      final responseData = await response.stream.bytesToString();

      // 🔍 DEBUG (VERY IMPORTANT)
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: $responseData");

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return data['secure_url'];
      } else {
        print("❌ Upload failed");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}