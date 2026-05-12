class Price {
  String id;
  String crop;
  String mandi;
  int price;
  DateTime date;

  Price({
    required this.id,
    required this.crop,
    required this.mandi,
    required this.price,
    required this.date,
  });

  // Object → Map
  Map<String, dynamic> toMap() {
    return {
      'crop': crop,
      'mandi': mandi,
      'price': price,
      'date': date,
    };
  }

  // Map → Object
  factory Price.fromMap(Map<String, dynamic> map, String docId) {
    return Price(
      id: docId,
      crop: map['crop'] ?? '',
      mandi: map['mandi'] ?? '',
      price: map['price'] ?? 0,
      date: map['date'] != null
          ? (map['date'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}