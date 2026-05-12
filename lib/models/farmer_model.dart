class Farmer {
  String id;
  String name;
  String phone;
  String location;
  List<String> crops;

  Farmer({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.crops,
  });

  // Convert object → Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'location': location,
      'crops': crops,
    };
  }

  // Convert Map → Object (from Firebase)
  factory Farmer.fromMap(Map<String, dynamic> map, String docId) {
    return Farmer(
      id: docId,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      crops: List<String>.from(map['crops'] ?? []),
    );
  }
}