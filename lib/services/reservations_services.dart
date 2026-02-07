import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation.dart';

class ReservationsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createReservation({
    required String adId,
    required String ownerId,
    required String reservedBy,
  }) async {
    // Ne dozvoli da vlasnik rezerviše svoj oglas
    if (ownerId == reservedBy) {
      throw Exception('Ne možeš rezervisati svoj oglas.');
    }

    // Optional: spreči duplikat pending rezervacije za isti oglas i korisnika
    final existing = await _db
        .collection('reservations')
        .where('adId', isEqualTo: adId)
        .where('reservedBy', isEqualTo: reservedBy)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Već imaš pending rezervaciju za ovaj oglas.');
    }

    await _db.collection('reservations').add({
      'adId': adId,
      'ownerId': ownerId,
      'reservedBy': reservedBy,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Reservation>> watchMyReservations(String uid) {
    return _db
        .collection('reservations')
        .where('reservedBy', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Reservation.fromDoc(d)).toList());
  }

  Stream<List<Reservation>> watchReservationsForMyAds(String uid) {
    return _db
        .collection('reservations')
        .where('ownerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Reservation.fromDoc(d)).toList());
  }

  Future<void> updateStatus({
    required String reservationId,
    required String status, // accepted/rejected/canceled
  }) async {
    await _db
        .collection('reservations')
        .doc(reservationId)
        .update({'status': status});
  }
}
