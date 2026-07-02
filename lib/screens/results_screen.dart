import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/market_model.dart';
import '../utils/result_utils.dart';
import 'manage_result_screen.dart';
import 'dart:async';

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

      appBar: AppBar(
        title: const Text("🎯 Result Management"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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

            const SizedBox(height: 20),

            Expanded(
  child: Card(
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1280,
        child: Column(
          children: [
                    /// Header
                    _buildHeader(),

                    /// Rows
                    Expanded(
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
                            itemCount:
                                markets.length,
                            separatorBuilder:
                                (_, __) =>
                                    const Divider(
                              height: 1,
                            ),
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

                             return Container(
  color: index.isEven
      ? Colors.white
      : const Color(0xffFAFAFA),
  child: Row(
    children: [

      _cell("${index + 1}", 50),

      _cell(market.name, 220),

      _cell(market.openTime, 110),

      _cell(market.closeTime, 110),

      _cell(latestResult, 170),

SizedBox(
  width: 150,
  child: Center(
    child: _statusBadge(status.status),
  ),
),
_cell(
  status.description,
  220,
),
   SizedBox(
  width: 120,
  child: Center(
    child: _priorityBadge(
      status.priorityText,
    ),
  ),
),

      SizedBox(
        width: 120,
        height: 55,
        child: Center(
          child: FilledButton.tonal(
  onPressed: () async {
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
  child: Text(status.action),
),
        ),
      ),
    ],
  ),
);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}