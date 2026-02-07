import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String adId;
  final String ownerId;
  final String reservedBy;
  final String status; // pending/accepted/rejected/canceled
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.adId,
    required this.ownerId,
    required this.reservedBy,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'adId': adId,
      'ownerId': ownerId,
      'reservedBy': reservedBy,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Reservation.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final ts = data['createdAt'];
    DateTime created = DateTime.now();
    if (ts is Timestamp) created = ts.toDate();

    return Reservation(
      id: doc.id,
      adId: (data['adId'] ?? '') as String,
      ownerId: (data['ownerId'] ?? '') as String,
      reservedBy: (data['reservedBy'] ?? '') as String,
      status: (data['status'] ?? 'pending') as String,
      createdAt: created,
    );
  }
}
