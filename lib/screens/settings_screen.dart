import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [

          SwitchListTile(
            title: Text("Dark Mode"),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {},
          ),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Change Password"),
          ),

          ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
          ),
        ],
      ),
    );
  }
}