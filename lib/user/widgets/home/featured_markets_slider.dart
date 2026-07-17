import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import '../../../utils/result_utils.dart';

class FeaturedMarketsSlider extends StatefulWidget {
  const FeaturedMarketsSlider({super.key});

  @override
  State<FeaturedMarketsSlider> createState() =>
      _FeaturedMarketsSliderState();
}

class _FeaturedMarketsSliderState
    extends State<FeaturedMarketsSlider> {
  final PageController _pageController =
      PageController(viewportFraction: .92);

  Timer? _timer;

  int _currentPage = 0;

  List<MarketModel> _featuredMarkets = [];

  @override
  void initState() {
    super.initState();

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!mounted) return;

        if (_featuredMarkets.isEmpty) return;

        if (!_pageController.hasClients) return;

        _currentPage++;

        if (_currentPage >= _featuredMarkets.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration:
              const Duration(milliseconds: 450),
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

        _featuredMarkets = snapshot.data!
            .where((market) => market.isFeatured)
            .toList();

        if (_featuredMarkets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "⭐ Featured Markets",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.4,
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 290,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _featuredMarkets.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final market =
                      _featuredMarkets[index];

                  final latest =
                      market.latestResult ?? {};

                  final open =
                      latest["openPanna"]?.toString() ??
                          "***";

                  final jodi =
                      latest["jodi"]?.toString() ??
                          "**";

                  final close =
                      latest["closePanna"]
                              ?.toString() ??
                          "***";

                  final status =
                      getMarketStatus(
                    openTime: market.openTime,
                    closeTime: market.closeTime,
                    todayResult: latest,
                  );

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      right: 14,
                    ),
                    child: _buildMarketCard(
                      market: market,
                      open: open,
                      jodi: jodi,
                      close: close,
                      status: status,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _featuredMarkets.length,
                  (index) {
                    final active =
                        index == _currentPage;

                    return AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 250,
                      ),
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      height: 8,
                      width:
                          active ? 28 : 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
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
  }) {
    final colors = _gradient(status.badge);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(.30),
            blurRadius: 25,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// TOP ROW
            Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),

                      SizedBox(width: 6),

                      Text(
                        "FEATURED",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Container(
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
                    children: [

                      const Icon(
                        Icons.visibility_rounded,
                        color: Colors.white,
                        size: 16,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${market.viewers}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 22),

            /// MARKET NAME
            Text(
              market.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -.5,
              ),
            ),

            const SizedBox(height: 24),

            /// RESULT
            Row(
              children: [

                Expanded(
                  child: _resultBox(open),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _resultBox(jodi),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _resultBox(close),
                ),

              ],
            ),

            const Spacer(),

            /// STATUS
            Row(
              children: [

                _statusChip(status),

                const Spacer(),

                const Icon(
                  Icons.schedule_rounded,
                  color: Colors.white70,
                  size: 17,
                ),

                const SizedBox(width: 6),

                Text(
                  "${market.openTime} → ${market.closeTime}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 18),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // TODO
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: colors.first,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [

                    Text(
                      "View Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(width: 8),

                    Icon(Icons.arrow_forward),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _resultBox(String value) {
    return Container(
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _statusChip(
    MarketStatus status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
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
            size: 17,
          ),

          const SizedBox(width: 6),

          Text(
            status.status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
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
          Color(0xff6D28D9),
          Color(0xff8B5CF6),
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