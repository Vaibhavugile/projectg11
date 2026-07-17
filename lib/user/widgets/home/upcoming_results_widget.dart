import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import '../../utils/countdown_utils.dart';
import '../../../utils/result_utils.dart';
import 'countdown_text.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final markets = snapshot.data ?? [];

        if (markets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "⏰ Upcoming Results",
            ),

            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: markets.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final market = markets[index];

                final marketStatus = getMarketStatus(
                  openTime: market.openTime,
                  closeTime: market.closeTime,
                  todayResult: market.latestResult,
                );

                return UpcomingResultCard(
                  marketName: market.name,

                  countdown: CountdownText(
                    openTime: market.openTime,
                    closeTime: market.closeTime,
                    todayResult: market.latestResult,
                  ),

                  status: marketStatus.status,

                  openTime: market.openTime,
                  closeTime: market.closeTime,

                  color: _statusColor(marketStatus),

                  onTap: () {
                    // TODO
                  },
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}