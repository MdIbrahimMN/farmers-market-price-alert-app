import 'package:flutter/material.dart';

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        Card(
          child: ListTile(
            title: Text("🌾 Crop prices rising in Karnataka"),
            subtitle: Text("Farmers getting better profits this week"),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("🌧 Rain expected in North India"),
            subtitle: Text("Good for wheat and rice crops"),
          ),
        ),
        Card(
          child: ListTile(
            title: Text("🚜 Government subsidy announced"),
            subtitle: Text("New schemes for farmers"),
          ),
        ),
      ],
    );
  }
}