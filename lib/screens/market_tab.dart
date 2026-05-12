import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/mandi_service.dart';

class MarketTab extends StatefulWidget {
  const MarketTab({super.key});

  @override
  State<MarketTab> createState() => _MarketTabState();
}

class _MarketTabState extends State<MarketTab> {
  final MandiService mandiService = MandiService();

  String selectedCategory = "Vegetables";
  String searchQuery = "";

  bool isVegetable(String crop) {
    final vegetables = [
      "onion",
      "brinjal",
      "tomato",
      "green chilli",
      "greenchilli",
      "cabbage",
      "capsicum",
      "carrot",
      "garlic",
      "ginger",
      "potato",
      "cucumber",
      "cauliflower",
      "radish",
      "pumpkin",
      "lemon",
    ];
    return vegetables.contains(crop.toLowerCase().trim());
  }

  bool isGrain(String crop) {
    final grains = [
      "wheat",
      "rice",
      "maize",
      "millets",
      "flour",
      "meal",
      "oats",
      "barley",
    ];
    return grains.contains(crop.toLowerCase().trim());
  }

  bool isFruit(String crop) {
    final fruits = [
      "mango",
      "apple",
      "banana",
      "kiwi",
      "orange",
      "pineapple",
      "pomegranate",
      "strawberry",
      "watermelon",
      "dragon fruit",
      "dates",
      "grapes",
      "black grapes",
    ];
    return fruits.contains(crop.toLowerCase().trim());
  }

  bool matchesCategory(String crop) {
    if (selectedCategory == "Vegetables") return isVegetable(crop);
    if (selectedCategory == "Grains") return isGrain(crop);
    return isFruit(crop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      body: Column(
        children: [
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A2238),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search crops...",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _categoryButton("Vegetables"),
                _categoryButton("Grains"),
                _categoryButton("Fruits"),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: mandiService.getAllPrices(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  );
                }

                final docs = snapshot.data!.docs;

                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final crop = (data['crop'] ?? "").toString();

                  return matchesCategory(crop) &&
                      crop.toLowerCase().contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Text(
                      "No $selectedCategory found",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredDocs[index].data() as Map<String, dynamic>;

                    final crop = data['crop'] ?? "Unknown";
                    final mandi = data['mandi'] ?? "Unknown";
                    final price = data['price'] ?? 0;
                    final image = data['image'] ?? "";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2238),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: image.toString().isNotEmpty
                                ? Image.network(
                                    image,
                                    height: 280,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 140,
                                    color: Colors.grey,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        crop,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        mandi,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "₹$price",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String category) {
    final isSelected = selectedCategory == category;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? Colors.green : const Color(0xFF1A2238),
          ),
          onPressed: () {
            setState(() {
              selectedCategory = category;
            });
          },
          child: Text(category),
        ),
      ),
    );
  }
}