import 'package:cloud_firestore/cloud_firestore.dart';

class ResultService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// Today's date (YYYY-MM-DD)
  String get today {
    final now = DateTime.now();

    return "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
  }

  /// Result Document ID
  String resultDocId(String marketId) {
    return "${marketId}_$today";
  }

  /// Load today's result
  Future<Map<String, dynamic>?> getTodayResult(
      String marketId) async {
    final doc = await _firestore
        .collection("results")
        .doc(resultDocId(marketId))
        .get();

    if (!doc.exists) {
      return null;
    }

    return doc.data();
  }
/// Update Market Latest Result
Future<void> updateMarketLatestResult({
  required String marketId,
  required Map<String, dynamic> latestResult,
}) async {
  await _firestore
      .collection("markets")
      .doc(marketId)
      .update({
    "latestResult": latestResult,
    "updatedAt": FieldValue.serverTimestamp(),
  });
}
/// Update Announcement
Future<void> updateAnnouncement({
  required String marketId,
  required String marketName,
  required String openPanna,
  required String jodi,
  required String closePanna,
}) async {
  await _firestore
      .collection("announcements")
      .doc("latest")
      .set({
    "marketId": marketId,
    "marketName": marketName,
    "openPanna": openPanna,
    "jodi": jodi,
    "closePanna": closePanna,
    "resultDate": today,
    "createdAt": FieldValue.serverTimestamp(),
  });
}
/// Update Breaking News
Future<void> updateBreakingNews({
  required String marketId,
  required String marketName,
  required String openPanna,
  required String jodi,
  required String closePanna,
}) async {
  final result = "$openPanna-$jodi-$closePanna";

  await _firestore
      .collection("breakingNews")
      .doc("latest")
      .set({
    "marketId": marketId,
    "marketName": marketName,
    "result": result,
    "resultDate": today,
    "updatedAt": FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
/// Update Weekly Panel Chart
Future<void> updatePanelChart({
  required String marketId,
  required String openPanna,
  required String jodi,
  required String closePanna,
}) async {
  final now = DateTime.now();

  final year = now.year;

  final dayOfYear = now
      .difference(DateTime(year, 1, 1))
      .inDays +
      1;

  final week =
      ((dayOfYear - now.weekday + 10) / 7).floor();

  final weekId =
      "week_${year}_${week.toString().padLeft(3, '0')}";

  final chartRef = _firestore
      .collection("markets")
      .doc(marketId)
      .collection("panelCharts")
      .doc(weekId);

  final chartSnap = await chartRef.get();

  if (!chartSnap.exists) {
    return;
  }

  final data = chartSnap.data()!;

  final List days =
      List.from(data["days"] ?? []);

  for (int i = 0; i < days.length; i++) {
    if (days[i]["date"] == today) {
      days[i]["open"] = openPanna;
      days[i]["jodi"] = jodi;
      days[i]["close"] = closePanna;
      break;
    }
  }

  await chartRef.update({
    "days": days,
    "updatedAt": FieldValue.serverTimestamp(),
  });
}
  /// Save Open Result
  Future<void> saveOpenResult({
    required String marketId,
    required String marketName,
    required String openPanna,
    required String openAnk,
  }) async {
    await _firestore
        .collection("results")
        .doc(resultDocId(marketId))
        .set(
      {
        "marketId": marketId,
        "marketName": marketName,

        "resultDate": today,

        "year": DateTime.now().year,

        "month": DateTime.now().month,

        "day": DateTime.now().day,

        "openPanna": openPanna,

        "openAnk": openAnk,

        "closePanna": "",

        "closeAnk": "",

        "jodi": "",

        "createdAt":
            FieldValue.serverTimestamp(),

        "updatedAt":
            FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  /// Save Close Result
  Future<void> saveCloseResult({
    required String marketId,
    required String closePanna,
    required String closeAnk,
    required String jodi,
  }) async {
    await _firestore
        .collection("results")
        .doc(resultDocId(marketId))
        .set(
      {
        "closePanna": closePanna,

        "closeAnk": closeAnk,

        "jodi": jodi,

        "updatedAt":
            FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}