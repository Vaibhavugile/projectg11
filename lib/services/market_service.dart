import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/market_model.dart';

class MarketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference<Map<String, dynamic>> _markets =
      FirebaseFirestore.instance.collection("markets");

  /// ==========================================
  /// Fetch All Markets
  /// ==========================================
  Future<List<MarketModel>> fetchMarkets() async {
    final snapshot = await _markets.get();

    final markets = snapshot.docs
        .map((doc) => MarketModel.fromFirestore(doc))
        .toList();

    markets.sort(
      (a, b) => a.sortOrder.compareTo(b.sortOrder),
    );

    return markets;
  }

  /// ==========================================
  /// Get Single Market
  /// ==========================================
  Future<MarketModel?> getMarket(String marketId) async {
    final doc = await _markets.doc(marketId).get();

    if (!doc.exists) {
      return null;
    }

    return MarketModel.fromFirestore(doc);
  }

  /// ==========================================
  /// Add Market
  /// ==========================================
  Future<void> addMarket({
    required String name,
    required String slug,
    required String openTime,
    required String closeTime,
    required int displayOrder,
    required int sortOrder,
    required int viewers,
    required bool isActive,
    required bool isFeatured,
    required bool favorite,
  }) async {
    final document = _markets.doc(slug);

    if ((await document.get()).exists) {
      throw Exception("Market with this slug already exists.");
    }

    await document.set({
      "name": name.trim(),
      "slug": slug.trim(),

      "openTime": openTime,
      "closeTime": closeTime,

      "displayOrder": displayOrder,
      "sortOrder": sortOrder,

      "viewers": viewers,

      "isActive": isActive,
      "isFeatured": isFeatured,
      "favorite": favorite,

      "latestResult": {
        "openPanna": "***",
        "openAnk": "*",
        "jodi": "**",
        "closePanna": "***",
        "closeAnk": "*",
        "resultDate": "",
      },

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ==========================================
  /// Update Market
  /// ==========================================
 /// ==========================================
/// Update Market
/// ==========================================
Future<void> updateMarket({
  required String marketId,
  required String name,
  required String slug,
  required String openTime,
  required String closeTime,
  required int displayOrder,
  required int sortOrder,
  required int viewers,
  required bool isActive,
  required bool isFeatured,
  required bool favorite,
}) async {
  final docRef = _markets.doc(marketId);

  final snapshot = await docRef.get();

  if (!snapshot.exists) {
    throw Exception("Market not found.");
  }

  await docRef.update({
    "name": name.trim(),
    "slug": slug.trim(),

    "openTime": openTime,
    "closeTime": closeTime,

    "displayOrder": displayOrder,
    "sortOrder": sortOrder,

    "viewers": viewers,

    "isActive": isActive,
    "isFeatured": isFeatured,
    "favorite": favorite,

    "updatedAt": FieldValue.serverTimestamp(),
  });
}

  /// ==========================================
  /// Delete Market
  /// ==========================================
  Future<void> deleteMarket(String marketId) async {
    await _markets.doc(marketId).delete();
  }

  /// ==========================================
  /// Toggle Active
  /// ==========================================
  Future<void> toggleActive(
    String marketId,
    bool value,
  ) async {
    await _markets.doc(marketId).update({
      "isActive": value,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ==========================================
  /// Toggle Featured
  /// ==========================================
  Future<void> toggleFeatured(
    String marketId,
    bool value,
  ) async {
    await _markets.doc(marketId).update({
      "isFeatured": value,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ==========================================
  /// Toggle Favorite
  /// ==========================================
  Future<void> toggleFavorite(
    String marketId,
    bool value,
  ) async {
    await _markets.doc(marketId).update({
      "favorite": value,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
  Stream<List<MarketModel>> streamMarkets() {
  return _markets
      .where("isActive", isEqualTo: true)
      .orderBy("sortOrder")
      .snapshots()
      .map((snapshot) {
    final markets = snapshot.docs
        .map((doc) => MarketModel.fromFirestore(doc))
        .toList();

    markets.sort(
      (a, b) => a.sortOrder.compareTo(b.sortOrder),
    );

    return markets;
  });
}
}
/// ==========================================
/// Stream Markets (Realtime)
/// ==========================================
