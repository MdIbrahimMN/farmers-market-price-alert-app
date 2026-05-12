import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

import 'alerts_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

import 'market_tab.dart';
import 'news_tab.dart';

import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 0;

  final screens = [
    null,
    MarketTab(),
    AlertsScreen(),
    NewsTab(),
    ProfileScreen(),
  ];

  // 🔥 HOME DASHBOARD
  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Good Morning 👋",
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),

          const SizedBox(height: 5),

          const Text(
            "Farmer",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 🔍 SEARCH
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search crop or mandi...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 📊 UPDATED CARDS
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: const [

              DashboardCard(
                title: "Alerts",
                value: "2",
                icon: Icons.notifications,
                color: Colors.red,
              ),

              DashboardCard(
                title: "Avg Price",
                value: "₹2240",
                icon: Icons.trending_up,
                color: Colors.orange,
              ),

              DashboardCard(
                title: "Markets",
                value: "12",
                icon: Icons.store,
                color: Colors.green,
              ),

              DashboardCard(
                title: "Weather",
                value: "28°C",
                icon: Icons.cloud,
                color: Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 📈 GRAPH TITLE
          const Text(
            "Price Trend (7 days)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // 📈 REAL GRAPH
          Container(
            height: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: FlDotData(show: false),

                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 1),
                      FlSpot(2, 4),
                      FlSpot(3, 3),
                      FlSpot(4, 5),
                      FlSpot(5, 4),
                      FlSpot(6, 6),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🤖 AI INSIGHT
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.teal],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "AI Insight: Onion prices expected to rise 📈",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      // 🔥 DRAWER
      drawer: Drawer(
        child: Column(
          children: [

            StreamBuilder(
              stream: ProfileService().getProfile(),
              builder: (context, snapshot) {

                String name = "No Name";
                String email = "";
                String image = "";

                if (snapshot.hasData && snapshot.data!.data() != null) {
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  name = data['name'] ?? "No Name";
                  email = data['email'] ?? "";
                  image = data['image'] ?? "";
                }

                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.green),
                  accountName: Text(name),
                  accountEmail: Text(email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        image.isNotEmpty ? NetworkImage(image) : null,
                    child: image.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
              },
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () async {
                await AuthService().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Mandi Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),
        ],
      ),

      body: currentIndex == 0 ? buildHome() : screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E293B),
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Market"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "News"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}