import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation.dart';

class ReservationsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Moje rezervacije (ja rezervisao)
  Stream<List<Reservation>> watchMyReservations(String uid) {
    return _db
        .collection('reservations')
        .where('reservedBy', isEqualTo: uid)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Reservation.fromDoc(d)).toList());
  }

  // ✅ Rezervacije za moje oglase (neko rezervisao moje)
  Stream<List<Reservation>> watchReservationsForMyAds(String ownerId) {
    return _db
        .collection('reservations')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Reservation.fromDoc(d)).toList());
  }

  /// ✅ Kreira rezervaciju odmah kao "reserved" sa datumom i vremenom.
  Future<void> createReservation({
    required String adId,
    required String adTitle,
    required String ownerId,
    required String reservedBy,
    required DateTime dateTime,
  }) async {
    await _db.collection('reservations').add({
      'adId': adId,
      'adTitle': adTitle, // ✅ NOVO
      'ownerId': ownerId,
      'reservedBy': reservedBy,
      'status': 'reserved',
      'dateTime': Timestamp.fromDate(dateTime),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ otkazivanje (ako hoćeš)
  Future<void> cancelReservation(String reservationId) async {
    await _db.collection('reservations').doc(reservationId).update({
      'status': 'canceled',
    });
  }
}
