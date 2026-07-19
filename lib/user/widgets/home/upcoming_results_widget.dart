import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import '../../../utils/result_utils.dart';
import '../../utils/countdown_utils.dart';
import 'countdown_text.dart';
import 'hero_result_card.dart';
import 'section_title.dart';
import 'upcoming_result_card.dart';

class UpcomingResultsWidget extends StatelessWidget {
  const UpcomingResultsWidget({super.key});

  Color _statusColor(MarketStatus status) {
    switch (status.badge) {
      case "completed":
        return Colors.green;

      case "overdue":
        return Colors.red;

      case "due":
        return Colors.orange;

      default:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MarketModel>>(
      stream: MarketService().streamMarkets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final markets = snapshot.data ?? [];

        if (markets.isEmpty) {
          return const SizedBox.shrink();
        }

        //==============================
        // Same Sorting as Admin
        //==============================
        markets.sort((a, b) {
          final sa = getMarketStatus(
            openTime: a.openTime,
            closeTime: a.closeTime,
            todayResult: a.latestResult,
          );

          final sb = getMarketStatus(
            openTime: b.openTime,
            closeTime: b.closeTime,
            todayResult: b.latestResult,
          );

          final priorityCompare =
              sb.priority.compareTo(sa.priority);

          if (priorityCompare != 0) {
            return priorityCompare;
          }

          final nextA = nextEventMinutes(
            openTime: a.openTime,
            closeTime: a.closeTime,
            todayResult: a.latestResult,
          );

          final nextB = nextEventMinutes(
            openTime: b.openTime,
            closeTime: b.closeTime,
            todayResult: b.latestResult,
          );

          return nextA.compareTo(nextB);
        });

        final topMarkets = markets.take(5).toList();

        if (topMarkets.isEmpty) {
          return const SizedBox.shrink();
        }

        final heroMarket = topMarkets.first;

        final heroStatus = getMarketStatus(
          openTime: heroMarket.openTime,
          closeTime: heroMarket.closeTime,
          todayResult: heroMarket.latestResult,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SectionTitle(
              title: "⭐ Next Result",
            ),

            HeroResultCard(
              marketName: heroMarket.name,

              countdown: CountdownText(
                openTime: heroMarket.openTime,
                closeTime: heroMarket.closeTime,
                todayResult: heroMarket.latestResult,
              ),

              status: heroStatus.status,

              openTime: heroMarket.openTime,

              closeTime: heroMarket.closeTime,

              color: _statusColor(heroStatus),

              onTap: () {},
            ),

            if (topMarkets.length > 1) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  12,
                ),
                child: SectionTitle(
                  title: "More Markets",
                ),
              ),

              ListView.separated(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: topMarkets.length - 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {

                  final market =
                      topMarkets[index + 1];

                  final marketStatus =
                      getMarketStatus(
                    openTime: market.openTime,
                    closeTime: market.closeTime,
                    todayResult: market.latestResult,
                  );

                  return UpcomingResultCard(
                    marketName: market.name,

                    countdown: CountdownText(
                      openTime: market.openTime,
                      closeTime: market.closeTime,
                      todayResult:
                          market.latestResult,
                    ),

                    status: marketStatus.status,

                    openTime: market.openTime,

                    closeTime: market.closeTime,

                    color:
                        _statusColor(marketStatus),

                    onTap: () {},
                  );
                },
              ),
            ],

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}