import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_service.dart';
import '../services/cloudinary_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final name = TextEditingController();
  final email = TextEditingController();
  final location = TextEditingController();

  Uint8List? webImage;

  bool isEditing = true;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (isEditing) await saveProfile();
              setState(() => isEditing = !isEditing);
            },
          )
        ],
      ),

      body: StreamBuilder(
        stream: ProfileService().getProfile(),
        builder: (context, snapshot) {

          Map<String, dynamic> data = {};

          if (snapshot.hasData && snapshot.data!.data() != null) {
            data = snapshot.data!.data() as Map<String, dynamic>;

            if (!isLoaded) {
              name.text = data['name'] ?? '';
              email.text = data['email'] ?? '';
              location.text = data['location'] ?? '';
              isLoaded = true;
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 20),

                GestureDetector(
                  onTap: isEditing ? pickImage : null,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],

                    backgroundImage: webImage != null
                        ? MemoryImage(webImage!)
                        : (data['image'] != null && data['image'] != "")
                            ? NetworkImage(data['image'])
                            : null,

                    child: (webImage == null &&
                            (data['image'] == null || data['image'] == ""))
                        ? Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),

                SizedBox(height: 10),

                if (isEditing)
                  Text("Tap image to change",
                      style: TextStyle(color: Colors.grey)),

                SizedBox(height: 20),

                buildField("Name", name),
                buildField("Email", email),
                buildField("Location", location),

                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // 📸 PICK IMAGE
  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      setState(() {
        webImage = bytes;
      });
    }
  }

  // 💾 SAVE PROFILE (CLOUDINARY)
  Future saveProfile() async {
    String imageUrl = "";

    try {
      if (webImage != null) {
        imageUrl =
            await CloudinaryService.uploadImage(webImage!) ?? "";
      }

      await ProfileService().updateProfile({
        'name': name.text,
        'email': email.text,
        'location': location.text,
        if (imageUrl.isNotEmpty) 'image': imageUrl,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Profile Saved ✅")));
    } catch (e) {
      print("Save Error: $e");
    }
  }
}