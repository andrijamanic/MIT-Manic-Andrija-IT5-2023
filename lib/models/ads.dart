import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  final String id;
  final String title;
  final String description;
  final String price;
  final String category;
  final String location;

  // Firebase
  final String userId;
  final DateTime createdAt;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.location,
    required this.userId,
    required this.createdAt,
  });

  factory Ad.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Ad(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      price: (data['price'] ?? '') as String,
      category: (data['category'] ?? '') as String,
      location: (data['location'] ?? '') as String,
      userId: (data['userId'] ?? '') as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'location': location,
        'userId': userId,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
