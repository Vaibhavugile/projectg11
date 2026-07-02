import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/market_model.dart';
import '../utils/result_utils.dart';
import 'manage_result_screen.dart';
import 'dart:async';
import '../widgets/result_task_card.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() =>
      _ResultsScreenState();
}

class _ResultsScreenState
    extends State<ResultsScreen> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final TextEditingController _searchController =
      TextEditingController();

  String _search = "";
Map<String, Map<String, dynamic>> _todayResults = {};

StreamSubscription<QuerySnapshot>? _resultsSubscription;
@override
void initState() {
  super.initState();

  _listenTodayResults();
}
 @override
void dispose() {
  _resultsSubscription?.cancel();

  _searchController.dispose();

  super.dispose();
}
  void _listenTodayResults() {
  _resultsSubscription?.cancel();

  _resultsSubscription = _firestore
      .collection("results")
      .where(
        "resultDate",
        isEqualTo: todayDate(),
      )
      .snapshots()
      .listen((snapshot) {
    final map = <String, Map<String, dynamic>>{};

    debugPrint(
        "============= TODAY RESULTS =============");

    for (final doc in snapshot.docs) {
      final data = doc.data();

      debugPrint("DOCUMENT ID : ${doc.id}");
      debugPrint("DATA : $data");

      final key = (data["marketId"] ?? "")
          .toString()
          .toLowerCase();

      debugPrint("MAP KEY : $key");

      map[key] = data;
    }

    if (!mounted) return;

    setState(() {
      _todayResults = map;
    });

    debugPrint(
        "TOTAL TODAY RESULTS : ${_todayResults.length}");

    debugPrint(_todayResults.toString());

    debugPrint(
        "=========================================");
  });
}
  Widget _headerCell(
  String title,
  double width,
) {
  return Container(
    width: width,
    height: 52,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      border: Border(
        right: BorderSide(
          color: Colors.deepPurple.shade300,
        ),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _cell(
  String value,
  double width,
) {
  return Container(
    width: width,
    height: 55,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    decoration: const BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Color(0xffE5E5E5),
        ),
      ),
    ),
    child: Text(
      value,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _buildHeader() {
  return Row(
    children: [

      _headerCell("#", 50),

      _headerCell("Market", 220),

      _headerCell("Open", 110),

      _headerCell("Close", 110),

      _headerCell("Latest Result", 170),

     _headerCell("Status", 140),

_headerCell("Description", 220),

      _headerCell("Priority", 120),

      _headerCell("Action", 120),

    ],
  );
}
Widget _statusBadge(String status) {
  Color bg;
  Color fg;

  switch (status.toLowerCase()) {
    case "completed":
      bg = Colors.green.shade100;
      fg = Colors.green.shade800;
      break;

    case "open due":
      bg = Colors.orange.shade100;
      fg = Colors.orange.shade800;
      break;

    case "close due":
      bg = Colors.deepOrange.shade100;
      fg = Colors.deepOrange.shade800;
      break;

    case "overdue":
      bg = Colors.red.shade100;
      fg = Colors.red.shade800;
      break;

    default:
      bg = Colors.grey.shade200;
      fg = Colors.grey.shade800;
  }

  return Container(
    width: 120,
    height: 32,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: fg,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}
Widget _priorityBadge(String priority) {
  Color bg;
  Color fg;

  switch (priority.toUpperCase()) {
    case "HIGH":
      bg = Colors.red.shade100;
      fg = Colors.red.shade800;
      break;

    case "MEDIUM":
      bg = Colors.orange.shade100;
      fg = Colors.orange.shade800;
      break;

    case "LOW":
      bg = Colors.green.shade100;
      fg = Colors.green.shade800;
      break;

    default:
      bg = Colors.blueGrey.shade100;
      fg = Colors.blueGrey.shade800;
  }

  return Container(
    width: 90,
    height: 32,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      priority,
      style: TextStyle(
        color: fg,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      

      body: SafeArea(
        child: Column(
          children: [
            Container(
        padding: const EdgeInsets.fromLTRB(
          22,
          20,
          22,
          16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Good Morning 👋",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Result Management",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight:
                              FontWeight.w800,
                          letterSpacing: -.8,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xff6A1B9A),
                        Color(0xff8E24AA),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(
                            18),
                  ),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 22),
            /// Search
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _search = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search market...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _search = "";
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 18),

SizedBox(
  height: 42,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [

      _filterChip(
        "All",
        true,
      ),

      const SizedBox(width: 10),

      _filterChip(
        "Overdue",
        false,
      ),

      const SizedBox(width: 10),

      _filterChip(
        "Due",
        false,
      ),

      const SizedBox(width: 10),

      _filterChip(
        "Completed",
        false,
      ),

      const SizedBox(width: 10),

      _filterChip(
        "Upcoming",
        false,
      ),

    ],
  ),
),

            const SizedBox(height: 20),
          
],
),
),

            Expanded(
  child: Card(
    clipBehavior: Clip.antiAlias,
    
                      child:
                          StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection("markets")
                            .orderBy("sortOrder")
                            .snapshots(),
                        builder:
                            (context, snapshot) {
                          if (snapshot
                                  .connectionState ==
                              ConnectionState
                                  .waiting) {
                            return const Center(
                              child:
                                  CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs
                                  .isEmpty) {
                            return const Center(
                              child: Text(
                                "No Markets Found",
                              ),
                            );
                          }

                          List<MarketModel>
                              markets = snapshot
                                  .data!.docs
                                  .map(
                                    (doc) =>
                                        MarketModel
                                            .fromFirestore(
                                                doc),
                                  )
                                  .toList();

                          if (_search
                              .isNotEmpty) {
                            markets = markets
                                .where((market) {
                              return market.name
                                      .toLowerCase()
                                      .contains(
                                          _search) ||
                                  market.slug
                                      .toLowerCase()
                                      .contains(
                                          _search);
                            }).toList();
                          }
               markets.sort((a, b) {
  final todayA =
      _todayResults[a.slug] ??
      a.latestResult;

  final todayB =
      _todayResults[b.slug] ??
      b.latestResult;

  final sa = getMarketStatus(
    openTime: a.openTime,
    closeTime: a.closeTime,
    todayResult: todayA,
  );

  final sb = getMarketStatus(
    openTime: b.openTime,
    closeTime: b.closeTime,
    todayResult: todayB,
  );

  // 1. Highest priority first
  final priorityCompare =
      sb.priority.compareTo(sa.priority);

  if (priorityCompare != 0) {
    return priorityCompare;
  }

  // 2. Same priority -> nearest event first
  final nextA = nextEventMinutes(
    openTime: a.openTime,
    closeTime: a.closeTime,
    todayResult: todayA,
  );

  final nextB = nextEventMinutes(
    openTime: b.openTime,
    closeTime: b.closeTime,
    todayResult: todayB,
  );

  return nextA.compareTo(nextB);
});

                         return ListView.separated(
  padding: const EdgeInsets.fromLTRB(
    16,
    12,
    16,
    24,
  ),
                            itemCount:
                                markets.length,
                            separatorBuilder: (_, __) =>
    const SizedBox(height: 14),
                            itemBuilder:
                                (context, index) {
                              final market =
                                  markets[index];
                                  debugPrint("--------------------------------");
debugPrint("Market Name : ${market.name}");
debugPrint("Market Slug : ${market.slug}");
debugPrint(
    "Today Result : ${_todayResults[market.slug]}");

                         final latest =
    _todayResults[market.slug] ??
    market.latestResult;

                              final latestResult =
                                  latest == null
                                      ? "***-**-***"
                                      : "${latest["openPanna"]}-${latest["jodi"]}-${latest["closePanna"]}";
                                      final status = getMarketStatus(
  openTime: market.openTime,
  closeTime: market.closeTime,
  todayResult: latest,
);
debugPrint(
    "Status : ${status.status}");
debugPrint(
    "Priority : ${status.priorityText}");

                            return ResultTaskCard(
  index: index,
  market: market,
  latestResult: latestResult,
  status: status,
  onTap: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManageResultScreen(
          marketId: market.id,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  },
);
                            },
                          );
                        },
                      ),
                    ),
            ),
                  ],
                ),
    
      ),
    
              );
          
  }
}
Widget _filterChip(
  String title,
  bool selected,
) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      gradient: selected
          ? const LinearGradient(
              colors: [
                Color(0xff6A1B9A),
                Color(0xff8E24AA),
              ],
            )
          : null,
      color: selected ? null : Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: selected
            ? Colors.transparent
            : Colors.grey.shade300,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Text(
      title,
      style: TextStyle(
        color: selected
            ? Colors.white
            : Colors.black87,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}