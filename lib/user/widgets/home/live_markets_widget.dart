import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import '../../../utils/result_utils.dart';
import 'live_market_card.dart';

class LiveMarketsWidget extends StatelessWidget {
  const LiveMarketsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MarketModel>>(
      stream: MarketService().streamMarkets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.center,
            ),
          );
        }

        final markets = snapshot.data ?? [];

        if (markets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                0,
              ),
              child: Row(
                children: [

                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(18),
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xff7C3AED),
                          Color(0xff5B21B6),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.casino_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Live Markets",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight:
                                FontWeight.w900,
                            height: 1,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Today's Active Markets",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xff6D28D9),
                      borderRadius:
                          BorderRadius.circular(
                        40,
                      ),
                    ),
                    child: Text(
                      "${markets.length}",
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            ListView.separated(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              itemCount: markets.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 18),
              itemBuilder: (context, index) {

                final market = markets[index];

                final latest =
                    market.latestResult ?? {};

                final status =
                    getMarketStatus(
                  openTime:
                      market.openTime,
                  closeTime:
                      market.closeTime,
                  todayResult: latest,
                );

                return LiveMarketCard(
                  marketName: market.name,

                  openPanna:
                      latest["openPanna"]
                              ?.toString() ??
                          "***",

                  jodi:
                      latest["jodi"]
                              ?.toString() ??
                          "**",

                  closePanna:
                      latest["closePanna"]
                              ?.toString() ??
                          "***",

                  openTime:
                      market.openTime,

                  closeTime:
                      market.closeTime,

                  status:
                      status.status,

                  statusColor:
                      _statusColor(
                    status.badge,
                  ),

                  featured:
                      market.isFeatured,

                  viewers:
                      market.viewers,

                  onTap: () {
                    // Navigate
                  },
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Color _statusColor(String badge) {
    switch (badge) {
      case "completed":
        return Colors.green;

      case "due":
        return Colors.orange;

      case "overdue":
        return Colors.red;

      default:
        return const Color(0xff7C3AED);
    }
  }
}