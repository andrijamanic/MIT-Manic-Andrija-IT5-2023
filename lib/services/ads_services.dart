import '../models/ads.dart';

class AdsService {
  // Placeholder funkcija – vraća sve oglase
  Future<List<Ad>> getAds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return dummyAds;
  }

  // Admin brisanje oglasa (privremeno, bez baze)
  Future<void> deleteAd(String id) async {
    dummyAds.removeWhere((ad) => ad.id == id);
  }

  // Kasnije ovde ide POST za dodavanje oglasa
}
