import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = AuthService();

  bool isLoading = false;
  bool obscurePassword = true;
  bool rememberMe = true;

  @override
  void initState() {
    super.initState();
    loadSavedLogin();
  }

  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    email.text = prefs.getString('email') ?? '';
    password.text = prefs.getString('password') ?? '';
  }

  Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', email.text.trim());
      await prefs.setString('password', password.text.trim());
    }
  }

  // 🔑 EMAIL LOGIN
  void loginUser() async {
    setState(() => isLoading = true);

    var user = await auth.login(
      email.text.trim(),
      password.text.trim(),
    );

    setState(() => isLoading = false);

    if (user != null) {
      await saveLogin();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed")),
      );
    }
  }

  // 🔥 GOOGLE LOGIN (FINAL FIXED)
  Future<void> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "837279673572-6o9rjkbg5tpdkt9cn255qucdsqgrgaru.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;

      // 🔥 SAVE USER FIRST TIME
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid);

      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          "name": user.displayName ?? "No Name",
          "email": user.email ?? "",
          "uid": user.uid,
          "createdAt": DateTime.now(),
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );

    } catch (e) {
      print("Google Login Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // 🌿 BACKGROUND GRADIENT
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade900, Colors.black],
                ),
              ),
            ),
          ),

          // 🌿 IMAGE OVERLAY
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.network(
                "https://i.imgur.com/8Km9tLL.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 🌾 LOTTIE
                  Lottie.asset('assets/farmer.json', height: 180),

                  SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),

                        child: Column(
                          children: [

                            Text("Welcome Back 🌿",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),

                            SizedBox(height: 20),

                            // 📧 EMAIL
                            TextField(
                              controller: email,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.green),
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            SizedBox(height: 15),

                            // 🔑 PASSWORD
                            TextField(
                              controller: password,
                              obscureText: obscurePassword,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.green),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (v) =>
                                      setState(() => rememberMe = v!),
                                ),
                                Text("Remember Me",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),

                            SizedBox(height: 15),

                            // 🔑 LOGIN BUTTON
                            isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: loginUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize:
                                          Size(double.infinity, 50),
                                    ),
                                    child: Text("Login"),
                                  ),

                            SizedBox(height: 10),

                            // 🔥 GOOGLE BUTTON
                            ElevatedButton.icon(
                              onPressed: googleLogin,
                              icon: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/281/281764.png",
                                height: 20,
                              ),
                              label: Text("Sign in with Google"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize:
                                    Size(double.infinity, 50),
                              ),
                            ),

                            SizedBox(height: 10),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          RegisterScreen()),
                                );
                              },
                              child: Text("Create Account",
                                  style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}