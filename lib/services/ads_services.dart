import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ads.dart';

class AdsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream svih oglasa (opciono sakrij oglase user-a)
  Stream<List<Ad>> watchAds({String? excludeUserId}) {
    return _db
        .collection('ads')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) => Ad.fromDoc(d)).toList();
      if (excludeUserId == null || excludeUserId.trim().isEmpty) return list;
      return list.where((a) => a.userId != excludeUserId).toList();
    });
  }

  /// ✅ Ovo ti treba zbog home_screen admin panela (FutureBuilder)
  Future<List<Ad>> getAds() async {
    final snap = await _db
        .collection('ads')
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) => Ad.fromDoc(d)).toList();
  }

  Future<void> addAd(Ad ad) async {
    final data = ad.toMap();

    if (ad.id.trim().isEmpty) {
      await _db.collection('ads').add(data);
    } else {
      await _db.collection('ads').doc(ad.id).set(data);
    }
  }

  Future<void> deleteAd(String adId) async {
    if (adId.trim().isEmpty) return;
    await _db.collection('ads').doc(adId).delete();
  }
}
