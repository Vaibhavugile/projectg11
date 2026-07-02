import 'package:flutter/material.dart';

import '../models/market_model.dart';

class MarketCard extends StatelessWidget {
  final MarketModel market;
  final int index;

  const MarketCard({
    super.key,
    required this.market,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final latestResult = market.latestResult;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================================
            /// Header
            /// ================================
            Row(
              children: [

                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        market.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        market.slug,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: market.isActive
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: Text(
                    market.isActive
                        ? "ACTIVE"
                        : "INACTIVE",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// ================================
            /// Time
            /// ================================
            Row(
              children: [

                Expanded(
                  child: _infoTile(
                    Icons.schedule,
                    "Open Time",
                    market.openTime,
                  ),
                ),

                Expanded(
                  child: _infoTile(
                    Icons.access_time,
                    "Close Time",
                    market.closeTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// ================================
            /// Orders
            /// ================================
            Row(
              children: [

                Expanded(
                  child: _infoTile(
                    Icons.swap_vert,
                    "Sort",
                    market.sortOrder.toString(),
                  ),
                ),

                Expanded(
                  child: _infoTile(
                    Icons.visibility,
                    "Viewers",
                    market.viewers.toString(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [

                if (market.isFeatured)
                  Chip(
                    avatar: const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                    backgroundColor:
                        Colors.orange.shade50,
                    label: const Text("Featured"),
                  ),

                if (market.favorite)
                  Chip(
                    avatar: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    backgroundColor:
                        Colors.red.shade50,
                    label: const Text("Favorite"),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            /// ================================
            /// Latest Result
            /// ================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: Column(
                children: [

                  const Text(
                    "Latest Result",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    latestResult == null
                        ? "---"
                        : "${latestResult["openPanna"]} - ${latestResult["jodi"]} - ${latestResult["closePanna"]}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    latestResult == null
                        ? "No Result"
                        : latestResult["resultDate"] ?? "",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// ================================
            /// Actions
            /// ================================
            Row(
              children: [

                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bar_chart),
                    label: const Text("Result"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.history),
                    label: const Text("History"),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [

        Icon(
          icon,
          size: 22,
          color: Colors.deepPurple,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}