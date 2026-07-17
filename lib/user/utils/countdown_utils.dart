import '../../utils/result_utils.dart';

/// =======================================================
/// NEXT MARKET EVENT
/// =======================================================

class NextMarketEvent {
  final String label;
  final Duration remaining;
  final bool completed;

  const NextMarketEvent({
    required this.label,
    required this.remaining,
    required this.completed,
  });
}

/// =======================================================
/// GET NEXT EVENT
/// =======================================================

NextMarketEvent getNextMarketEvent({
  required String openTime,
  required String closeTime,
  required Map<String, dynamic>? todayResult,
}) {
  final nextMinutes = nextEventMinutes(
    openTime: openTime,
    closeTime: closeTime,
    todayResult: todayResult,
  );

  // Market completed
  if (nextMinutes == 9999) {
    return const NextMarketEvent(
      label: "Completed",
      remaining: Duration.zero,
      completed: true,
    );
  }

  final now = DateTime.now();

  final currentMinutes =
      now.hour * 60 + now.minute;

  int remainingMinutes =
      nextMinutes - currentMinutes;

  if (remainingMinutes < 0) {
    remainingMinutes = 0;
  }

  final latest = todayResult ?? {};

  final hasToday =
      latest["resultDate"]?.toString() ==
          todayDate();

  final openPanna =
      latest["openPanna"]?.toString() ?? "";

  final openEntered =
      openPanna.isNotEmpty &&
      openPanna != "***";

  final label =
      (!hasToday || !openEntered)
          ? "Open In"
          : "Close In";

  return NextMarketEvent(
    label: label,
    remaining: Duration(
      minutes: remainingMinutes,
    ),
    completed: false,
  );
}

/// =======================================================
/// FORMAT DURATION
/// 01:25:42
/// =======================================================

String formatDuration(Duration duration) {
  final hours =
      duration.inHours.toString().padLeft(2, '0');

  final minutes =
      (duration.inMinutes % 60)
          .toString()
          .padLeft(2, '0');

  final seconds =
      (duration.inSeconds % 60)
          .toString()
          .padLeft(2, '0');

  return "$hours:$minutes:$seconds";
}

/// =======================================================
/// STATUS COLOR
/// =======================================================

String getStatusLabel({
  required String openTime,
  required String closeTime,
  required Map<String, dynamic>? todayResult,
}) {
  final status = getMarketStatus(
    openTime: openTime,
    closeTime: closeTime,
    todayResult: todayResult,
  );

  return status.status;
}

/// =======================================================
/// BADGE COLOR
/// =======================================================

int getStatusColorValue({
  required String openTime,
  required String closeTime,
  required Map<String, dynamic>? todayResult,
}) {
  final status = getMarketStatus(
    openTime: openTime,
    closeTime: closeTime,
    todayResult: todayResult,
  );

  switch (status.badge) {
    case "completed":
      return 0xFF10B981;

    case "due":
      return 0xFFF59E0B;

    case "overdue":
      return 0xFFEF4444;

    default:
      return 0xFF6366F1;
  }
}

/// =======================================================
/// STATUS DESCRIPTION
/// =======================================================

String getStatusDescription({
  required String openTime,
  required String closeTime,
  required Map<String, dynamic>? todayResult,
}) {
  return getMarketStatus(
    openTime: openTime,
    closeTime: closeTime,
    todayResult: todayResult,
  ).description;
}