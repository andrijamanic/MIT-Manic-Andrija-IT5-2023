import '../models/ads.dart';

class AdsService {
  // Placeholder funkcija – vraća sve oglase
  Future<List<Ad>> getAds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return dummyAds;
  }

  // Kasnije ovde ide POST za dodavanje oglasa
}
