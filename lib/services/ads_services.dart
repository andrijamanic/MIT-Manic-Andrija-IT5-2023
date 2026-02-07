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

  /// ✅ Seed: 2 oglasa po kategoriji (samo ako je baza prazna)
  Future<void> seedAdsIfEmpty() async {
    final check = await _db.collection('ads').limit(1).get();
    if (check.docs.isNotEmpty) return;

    final batch = _db.batch();

    final samples = <Map<String, dynamic>>[
      // Stanovi (2)
      {
        'title': 'Garsonjera kod centra',
        'description': 'Namešteno, odmah useljivo. Depozit 1 kirija.',
        'price': '350€',
        'category': 'Stanovi',
        'location': 'Novi Sad',
        'userId': 'seed_admin',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Dvosoban stan - Liman',
        'description': 'Blizu fakulteta, mirno naselje. Internet uključen.',
        'price': '500€',
        'category': 'Stanovi',
        'location': 'Novi Sad',
        'userId': 'seed_admin',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Prakse (2)
      {
        'title': 'Praksa - Flutter junior',
        'description': '3 meseca, remote, mentorstvo + code review.',
        'price': 'Plaćena',
        'category': 'Prakse',
        'location': 'Remote',
        'userId': 'seed_admin',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Praksa - QA tester',
        'description': 'Manual + uvod u automatizaciju, realan projekat.',
        'price': 'Plaćena',
        'category': 'Prakse',
        'location': 'Beograd',
        'userId': 'seed_admin',
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Ostalo (2)
      {
        'title': 'Prodajem bicikl',
        'description': 'Dobro očuvan, gradska vožnja, 26".',
        'price': '120€',
        'category': 'Ostalo',
        'location': 'Beograd',
        'userId': 'seed_admin',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Časovi matematike',
        'description': 'Priprema za prijemni i kolokvijume, online.',
        'price': '1000din/h',
        'category': 'Ostalo',
        'location': 'Online',
        'userId': 'seed_admin',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final data in samples) {
      final ref = _db.collection('ads').doc();
      batch.set(ref, data);
    }

    await batch.commit();
  }
}
