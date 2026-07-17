import 'package:flutter/material.dart';

import '../../../models/market_model.dart';
import '../../../services/market_service.dart';
import 'live_market_card.dart';
import 'section_title.dart';

class LiveMarketsWidget extends StatelessWidget {
  const LiveMarketsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MarketModel>>(
      stream: MarketService().streamMarkets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
            child: Center(
              child: Text(
                "Something went wrong.\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final markets = snapshot.data ?? [];

        if (markets.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text("No markets available"),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "🎲 Live Markets",
            ),

            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: markets.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                final market = markets[index];

                final latest = market.latestResult ?? {};

                final openPanna =
                    latest["openPanna"]?.toString() ?? "***";

                final jodi =
                    latest["jodi"]?.toString() ?? "**";

                final closePanna =
                    latest["closePanna"]?.toString() ?? "***";

                final result =
                    "$openPanna - $jodi - $closePanna";

                // Temporary status
                String status = "Upcoming";
                Color statusColor = Colors.blue;

                if (jodi != "**") {
                  status = "Result Declared";
                  statusColor = Colors.green;
                }

                return LiveMarketCard(
                  marketName: market.name,
                  result: result,
                  openTime: market.openTime,
                  closeTime: market.closeTime,
                  status: status,
                  statusColor: statusColor,
                  featured: market.isFeatured,
                  viewers: market.viewers,
                  onTap: () {
                    // TODO:
                    // Navigator.push(...)
                    // Market Details Screen
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
}