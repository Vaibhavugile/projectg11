import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import '../../../utils/result_utils.dart';

class PopularMarketsWidget extends StatefulWidget {
  const PopularMarketsWidget({super.key});

  @override
  State<PopularMarketsWidget> createState() =>
      _PopularMarketsWidgetState();
}

class _PopularMarketsWidgetState
    extends State<PopularMarketsWidget> {
  final PageController _pageController =
      PageController(
    viewportFraction: .42,
  );

  Timer? _timer;

  int _currentPage = 0;

  List<MarketModel> _markets = [];

  @override
  void initState() {
    super.initState();

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        if (!mounted) return;

        if (_markets.isEmpty) return;

        if (!_pageController.hasClients) return;

        _currentPage++;

        if (_currentPage >= _markets.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(
            milliseconds: 450,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MarketModel>>(
      stream: MarketService().streamMarkets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final markets = snapshot.data!
            .where((m) => m.isActive)
            .toList();

        markets.sort(
          (a, b) =>
              b.viewers.compareTo(a.viewers),
        );

        _markets = markets.take(10).toList();

        if (_markets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [

                  const Text(
                    "🔥 Popular Markets",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View All",
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                padEnds: false,
                itemCount: _markets.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder:
                    (context, index) {
                  final market =
                      _markets[index];

                  final latest =
                      market.latestResult ??
                          {};

                  final open =
                      latest["openPanna"]
                              ?.toString() ??
                          "***";

                  final jodi =
                      latest["jodi"]
                              ?.toString() ??
                          "**";

                  final close =
                      latest["closePanna"]
                              ?.toString() ??
                          "***";

                  final status =
                      getMarketStatus(
                    openTime:
                        market.openTime,
                    closeTime:
                        market.closeTime,
                    todayResult: latest,
                  );

                  final active =
                      index ==
                          _currentPage;

                  return AnimatedScale(
                    duration:
                        const Duration(
                      milliseconds: 300,
                    ),
                    scale:
                        active ? 1 : .92,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        left: 14,
                        bottom: 10,
                      ),
                      child: _buildMarketCard(
                        market: market,
                        open: open,
                        jodi: jodi,
                        close: close,
                        status: status,
                        active: active,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: List.generate(
                  _markets.length,
                  (index) {
                    final active =
                        index ==
                            _currentPage;

                    return AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 250,
                      ),
                      margin:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 3,
                      ),
                      width:
                          active ? 22 : 7,
                      height: 7,
                      decoration:
                          BoxDecoration(
                        color: active
                            ? Colors
                                .deepPurple
                            : Colors.grey
                                .shade300,
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

          ],
        );
      },
    );
  }
    Widget _buildMarketCard({
    required MarketModel market,
    required String open,
    required String jodi,
    required String close,
    required MarketStatus status,
    required bool active,
  }) {
    final colors = _gradient(status.badge);

    return GestureDetector(
      onTap: () {
        // TODO
        // Open Market Details
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(.15),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(
                active ? .35 : .18,
              ),
              blurRadius: active ? 24 : 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// TOP ROW
              Row(
                children: [

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 15,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [

                      const Icon(
                        Icons.visibility_rounded,
                        size: 15,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "${market.viewers}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(height: 14),

              /// MARKET NAME
              Text(
                market.name,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const Spacer(),

              /// RESULT
              Center(
                child: Column(
                  children: [

                    Text(
                      open,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      jodi,
                      style:
                          const TextStyle(
                        color: Colors.amber,
                        fontSize: 30,
                        fontWeight:
                            FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      close,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                  ],
                ),
              ),

              const Spacer(),

              /// STATUS
              _statusChip(status),

              const SizedBox(height: 10),

              /// TIME
              Row(
                children: [

                  const Icon(
                    Icons.schedule,
                    size: 13,
                    color: Colors.white70,
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      "${market.openTime} - ${market.closeTime}",
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(
    MarketStatus status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            _statusIcon(status.badge),
            color: Colors.white,
            size: 13,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              status.status,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

        ],
      ),
    );
  }
    List<Color> _gradient(String badge) {
    switch (badge) {
      case "completed":
        return const [
          Color(0xff059669),
          Color(0xff10B981),
        ];

      case "due":
        return const [
          Color(0xffD97706),
          Color(0xffF59E0B),
        ];

      case "overdue":
        return const [
          Color(0xffDC2626),
          Color(0xffEF4444),
        ];

      default:
        return const [
          Color(0xff5B21B6),
          Color(0xff7C3AED),
        ];
    }
  }

  IconData _statusIcon(String badge) {
    switch (badge) {
      case "completed":
        return Icons.check_circle_rounded;

      case "due":
        return Icons.access_time_filled_rounded;

      case "overdue":
        return Icons.warning_amber_rounded;

      default:
        return Icons.schedule_rounded;
    }
  }
}