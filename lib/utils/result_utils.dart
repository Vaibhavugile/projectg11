class MarketStatus {
  final String status;
  final String description;
  final String badge;
  final int priority;
  final String action;
  final String priorityText;

  const MarketStatus({
    required this.status,
    required this.description,
    required this.badge,
    required this.priority,
    required this.action,
    required this.priorityText,
  });
}

/// ==========================================
/// CURRENT DATE (IST)
/// ==========================================

String todayDate() {
  final now = DateTime.now().toUtc().add(
    const Duration(hours: 5, minutes: 30),
  );

  return "${now.year.toString().padLeft(4, '0')}-"
      "${now.month.toString().padLeft(2, '0')}-"
      "${now.day.toString().padLeft(2, '0')}";
}

/// ==========================================
/// TIME TO MINUTES
/// ==========================================

int timeToMinutes(String? time) {
  if (time == null || time.isEmpty) {
    return 0;
  }

  final parts = time.split(" ");

  final clock = parts[0];

  final period =
      parts.length > 1 ? parts[1] : "AM";

  final hm = clock.split(":");

  int hour = int.parse(hm[0]);

  final minute = int.parse(hm[1]);

  if (period == "PM" && hour != 12) {
    hour += 12;
  }

  if (period == "AM" && hour == 12) {
    hour = 0;
  }

  return hour * 60 + minute;
}
int nextEventMinutes({
  required String openTime,
  required String closeTime,
  required Map<String, dynamic>? todayResult,
}) {
  final latest = todayResult ?? {};

  final hasTodayResult =
      latest["resultDate"]?.toString() == todayDate();

  final openPanna =
      latest["openPanna"]?.toString() ?? "";

  final closePanna =
      latest["closePanna"]?.toString() ?? "";

  final openEntered =
      openPanna.isNotEmpty &&
      openPanna != "***";

  final closeEntered =
      closePanna.isNotEmpty &&
      closePanna != "***";

  final openMinutes =
      timeToMinutes(openTime);

  final closeMinutes =
      timeToMinutes(closeTime);

  int nextMinutes;

  // No result today -> next event is OPEN
  if (!hasTodayResult) {
    nextMinutes = openMinutes;
  }

  // Open pending -> next event is OPEN
  else if (!openEntered) {
    nextMinutes = openMinutes;
  }

  // Close pending -> next event is CLOSE
  else if (!closeEntered) {
    nextMinutes = closeMinutes;
  }

  // Completed
  else {
    nextMinutes = 9999;
  }

  print("====================================");
  print("OPEN TIME      : $openTime");
  print("CLOSE TIME     : $closeTime");
  print("TODAY RESULT   : $latest");
  print("HAS TODAY      : $hasTodayResult");
  print("OPEN PANNA     : $openPanna");
  print("CLOSE PANNA    : $closePanna");
  print("OPEN ENTERED   : $openEntered");
  print("CLOSE ENTERED  : $closeEntered");
  print("NEXT MINUTES   : $nextMinutes");
  print("====================================");

  return nextMinutes;
}

/// ==========================================
/// MARKET STATUS
/// ==========================================

MarketStatus getMarketStatus({
  required String openTime,
  required String closeTime,
  required Map<String, dynamic>? todayResult,
}) {
  final now = DateTime.now();

  final currentMinutes =
    now.hour * 60 + now.minute;

  final openMinutes =
      timeToMinutes(openTime);

  final closeMinutes =
      timeToMinutes(closeTime);
print("NOW = ${now.hour}:${now.minute}");
print("CURRENT = $currentMinutes");
print("OPEN TIME = $openTime");
print("OPEN = $openMinutes");
print("CURRENT > OPEN = ${currentMinutes > openMinutes}");

  final latest = todayResult ?? {};

  final today = todayDate();

  final resultDate =
    latest["resultDate"]?.toString() ?? "";

final hasTodayResult =
    resultDate == today;

final openPanna =
    latest["openPanna"]?.toString() ?? "";

final closePanna =
    latest["closePanna"]?.toString() ?? "";

final openEntered =
    openPanna.isNotEmpty &&
    openPanna != "***";

final closeEntered =
    closePanna.isNotEmpty &&
    closePanna != "***";
  /// ==========================================
  /// COMPLETED
  /// ==========================================

  if (hasTodayResult &&
      openEntered &&
      closeEntered) {
    return const MarketStatus(
      status: "Completed",
      description: "Today's result saved",
      badge: "completed",
      priority: 0,
      action: "Edit Result",
      priorityText: "DONE",
    );
  }

  /// ==========================================
  /// OPEN OVERDUE
  /// ==========================================

  if (currentMinutes > openMinutes &&
      !hasTodayResult) {
    return MarketStatus(
      status: "Open Overdue",
      description:
          "${currentMinutes - openMinutes} mins late",
      badge: "overdue",
      priority: 1000,
      action: "Enter Open",
      priorityText: "HIGH",
    );
  }

  /// ==========================================
  /// CLOSE OVERDUE
  /// ==========================================

  if (currentMinutes > closeMinutes &&
      hasTodayResult &&
      openEntered &&
      !closeEntered) {
    return MarketStatus(
      status: "Close Overdue",
      description:
          "${currentMinutes - closeMinutes} mins late",
      badge: "overdue",
      priority: 900,
      action: "Enter Close",
      priorityText: "HIGH",
    );
  }

  /// ==========================================
  /// OPEN DUE
  /// ==========================================

  if (currentMinutes >= openMinutes - 15 &&
      currentMinutes < openMinutes &&
      !hasTodayResult) {
    return MarketStatus(
      status: "Open Due",
      description:
          "${openMinutes - currentMinutes} mins remaining",
      badge: "due",
      priority: 700,
      action: "Enter Open",
      priorityText: "MEDIUM",
    );
  }

  /// ==========================================
  /// CLOSE DUE
  /// ==========================================

  if (currentMinutes >= closeMinutes - 15 &&
      currentMinutes < closeMinutes &&
      hasTodayResult &&
      openEntered &&
      !closeEntered) {
    return MarketStatus(
      status: "Close Due",
      description:
          "${closeMinutes - currentMinutes} mins remaining",
      badge: "due",
      priority: 600,
      action: "Enter Close",
      priorityText: "MEDIUM",
    );
  }

  /// ==========================================
  /// UPCOMING
  /// ==========================================

  final mins =
      openMinutes - currentMinutes;

  final hrs = mins ~/ 60;

  final rem = mins % 60;

  return MarketStatus(
    status: "Upcoming",
    description: hrs > 0
        ? "${hrs}h ${rem}m remaining"
        : "$mins mins remaining",
    badge: "upcoming",
    priority: 300,
    action: "View",
    priorityText: "LOW",
  );
}