import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ads.dart';

class AdsService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Ad>> watchAds() {
    return _db
        .collection('ads')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Ad.fromDoc(d)).toList());
  }

  Future<List<Ad>> getAds() async {
    final snap = await _db
        .collection('ads')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => Ad.fromDoc(d)).toList();
  }

  Future<void> addAd(Ad ad) async {
    await _db.collection('ads').add(ad.toMap());
  }

  Future<void> deleteAd(String adId) async {
    await _db.collection('ads').doc(adId).delete();
  }
}
