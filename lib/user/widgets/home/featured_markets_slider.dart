import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import '../../../utils/result_utils.dart';

class FeaturedMarketsSlider extends StatefulWidget {
  const FeaturedMarketsSlider({
    super.key,
  });

  @override
  State<FeaturedMarketsSlider> createState() =>
      _FeaturedMarketsSliderState();
}

class _FeaturedMarketsSliderState
    extends State<FeaturedMarketsSlider> {

  /// Slider Controller
  late final PageController _pageController;
late final Stream<List<MarketModel>> _marketsStream;
  /// Auto Scroll Timer
  Timer? _timer;

  /// Current Page
  int _currentPage = 0;

  /// Featured Markets
  List<MarketModel> _featuredMarkets = [];

  /// Animation Settings
  static const Duration _autoSlideDuration =
      Duration(seconds: 4);

  static const Duration _pageAnimationDuration =
      Duration(milliseconds: 550);

 @override
void initState() {
  super.initState();

  _marketsStream = MarketService().streamMarkets();

  _pageController = PageController(
    viewportFraction: 0.90,
    initialPage: 0,
    keepPage: true,
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _startAutoSlide();
  });
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
       stream: _marketsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 380,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        _featuredMarkets = snapshot.data!
            .where((market) => market.isFeatured)
            .toList();

        if (_featuredMarkets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Premium Heading
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.deepPurple,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Featured Markets",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -.6,
                          ),
                        ),

                        SizedBox(height: 2),

                        Text(
                          "Today's most active markets",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Text(
                      "${_featuredMarkets.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// Premium Slider
            SizedBox(
              height: 510,
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const BouncingScrollPhysics(),
                padEnds: false,
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
                      latest["openPanna"]
                              ?.toString() ??
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

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {

                      double scale = 1.0;

                      if (_pageController.hasClients &&
                          _pageController.position
                              .haveDimensions) {
                        final page =
                            _pageController.page ??
                                _currentPage.toDouble();

                        scale =
                            (1 - ((page - index).abs() * .08))
                                .clamp(.92, 1.0);
                      }

                      return Transform.scale(
                        scale: scale,
                        child: Padding(
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 22),

            /// Premium Indicator
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _featuredMarkets.length,
                  (index) {

                    final active =
                        index == _currentPage;

                    return AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      curve: Curves.easeInOut,
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      height: 8,
                      width: active ? 34 : 8,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                        color: active
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: Colors
                                      .deepPurple
                                      .withOpacity(.35),
                                  blurRadius: 8,
                                ),
                              ]
                            : [],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),
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
      borderRadius: BorderRadius.circular(32),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      boxShadow: [
        BoxShadow(
          color: colors.first.withOpacity(.35),
          blurRadius: 35,
          spreadRadius: 2,
          offset: const Offset(0, 16),
        ),
      ],
    ),
    child: Stack(
      children: [

        /// Decorative Circle
        Positioned(
          top: -70,
          right: -50,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.08),
            ),
          ),
        ),

        Positioned(
          bottom: -55,
          left: -35,
          child: Icon(
            Icons.casino_rounded,
            size: 170,
            color: Colors.white.withOpacity(.05),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Top Row
              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius:
                          BorderRadius.circular(40),
                      border: Border.all(
                        color:
                            Colors.white.withOpacity(.25),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),

                        SizedBox(width: 6),

                        Text(
                          "FEATURED",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [

                        const Icon(
                          Icons.visibility_rounded,
                          size: 17,
                          color: Colors.white,
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

              /// Market Name
              Text(
                market.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.8,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Today's Featured Market",
                style: TextStyle(
                  color: Colors.white.withOpacity(.75),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 26),

              /// Result Boxes
              Row(
                children: [

                  Expanded(
                    child: _resultBox(
                      title: "OPEN",
                      value: open,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _resultBox(
                      title: "JODI",
                      value: jodi,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _resultBox(
                      title: "CLOSE",
                      value: close,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Divider
              Container(
                height: 1,
                color: Colors.white.withOpacity(.15),
              ),

              const SizedBox(height: 20),
                            /// Status & Time
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: _statusChip(status),
                  ),

                  const SizedBox(width: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Icon(
                          Icons.schedule_rounded,
                          color: Colors.white,
                          size: 17,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "${market.openTime} - ${market.closeTime}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// Premium Button
              SizedBox(
                width: double.infinity,
                height: 56,
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

                      Icon(
                        Icons.insights_rounded,
                        size: 20,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "View Complete Result",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .2,
                        ),
                      ),

                      SizedBox(width: 10),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Bottom Info
              Row(
                children: [

                  Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: Colors.white.withOpacity(.9),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "Updated Live",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "Play Smart • Stay Updated",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
 Widget _resultBox({
  required String title,
  required String value,
}) {
  return Container(
    height: 90,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.95),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
            letterSpacing: 1,
            height: 1,
          ),
        ),
      ],
    ),
  );
}

Widget _statusChip(MarketStatus status) {
  Color chipColor;

  switch (status.badge) {
    case "completed":
      chipColor = const Color(0xff10B981);
      break;

    case "due":
      chipColor = const Color(0xffF59E0B);
      break;

    case "overdue":
      chipColor = const Color(0xffEF4444);
      break;

    default:
      chipColor = const Color(0xff8B5CF6);
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.14),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: Colors.white.withOpacity(.20),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: chipColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: chipColor.withOpacity(.55),
                blurRadius: 8,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Icon(
          _statusIcon(status.badge),
          color: Colors.white,
          size: 18,
        ),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            status.status.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: .5,
            ),
          ),
        ),
      ],
    ),
  );
}
  List<Color> _gradient(String badge) {
  switch (badge.toLowerCase()) {

    /// Result Declared
    case "completed":
      return const [
        Color(0xff047857),
        Color(0xff10B981),
        Color(0xff34D399),
      ];

    /// Market Running
    case "due":
      return const [
        Color(0xffB45309),
        Color(0xffF59E0B),
        Color(0xffFBBF24),
      ];

    /// Market Closed
    case "overdue":
      return const [
        Color(0xffB91C1C),
        Color(0xffEF4444),
        Color(0xffF87171),
      ];

    /// Upcoming
    default:
      return const [
        Color(0xff5B21B6),
        Color(0xff7C3AED),
        Color(0xffA855F7),
      ];
  }
}

IconData _statusIcon(String badge) {
  switch (badge.toLowerCase()) {

    case "completed":
      return Icons.verified_rounded;

    case "due":
      return Icons.bolt_rounded;

    case "overdue":
      return Icons.lock_clock_rounded;

    default:
      return Icons.auto_awesome_rounded;
  }
}

/// Optional: Better Status Text
String _statusTitle(String badge) {
  switch (badge.toLowerCase()) {

    case "completed":
      return "RESULT DECLARED";

    case "due":
      return "LIVE NOW";

    case "overdue":
      return "MARKET CLOSED";

    default:
      return "UPCOMING";
  }
}

/// Optional: Small Emoji
String _statusEmoji(String badge) {
  switch (badge.toLowerCase()) {

    case "completed":
      return "✅";

    case "due":
      return "🟢";

    case "overdue":
      return "🔴";

    default:
      return "⭐";
  }
}

/// Optional Viewer Formatter
String _formatViewers(int viewers) {
  if (viewers >= 1000000) {
    return "${(viewers / 1000000).toStringAsFixed(1)}M";
  }

  if (viewers >= 1000) {
    return "${(viewers / 1000).toStringAsFixed(1)}K";
  }

  return viewers.toString();
}
}