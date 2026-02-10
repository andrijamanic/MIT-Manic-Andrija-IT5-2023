import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String adId;
  final String ownerId;
  final String reservedBy;
  final String status;
  final DateTime? dateTime;
  final String? adTitle; // ✅

  Reservation({
    required this.id,
    required this.adId,
    required this.ownerId,
    required this.reservedBy,
    required this.status,
    required this.dateTime,
    required this.adTitle,
  });

  factory Reservation.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data['dateTime'];

    return Reservation(
      id: doc.id,
      adId: (data['adId'] ?? '') as String,
      ownerId: (data['ownerId'] ?? '') as String,
      reservedBy: (data['reservedBy'] ?? '') as String,
      status: (data['status'] ?? '') as String,
      dateTime: ts is Timestamp ? ts.toDate() : null,
      adTitle: data['adTitle'] as String?,
    );
  }
}
