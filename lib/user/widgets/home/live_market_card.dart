import 'package:flutter/material.dart';

class LiveMarketCard extends StatelessWidget {
  final String marketName;
  final String openPanna;
  final String jodi;
  final String closePanna;
  final String openTime;
  final String closeTime;
  final String status;
  final Color statusColor;
  final bool featured;
  final int viewers;
  final VoidCallback? onTap;

  const LiveMarketCard({
    super.key,
    required this.marketName,
    required this.openPanna,
    required this.jodi,
    required this.closePanna,
    required this.openTime,
    required this.closeTime,
    required this.status,
    required this.statusColor,
    this.featured = false,
    this.viewers = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLive =
        status.toLowerCase().contains("live");

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff4C1D95),
                Color(0xff6D28D9),
                Color(0xff8B5CF6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff6D28D9)
                    .withOpacity(.25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [

              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.08),
                  ),
                ),
              ),

              Positioned(
                left: -30,
                bottom: -30,
                child: Icon(
                  Icons.casino_rounded,
                  size: 140,
                  color: Colors.white.withOpacity(.05),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [

                              Icon(
                                featured
                                    ? Icons.workspace_premium
                                    : Icons.casino,
                                color: Colors.amber,
                                size: 16,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                featured
                                    ? "FEATURED"
                                    : "MARKET",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [

                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                                size: 16,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                _formatViewers(viewers),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      marketName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [

                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLive
                                ? Colors.greenAccent
                                : Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.12),
                        borderRadius:
                            BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [

                          Expanded(
                            child: _resultBox(
                              "OPEN",
                              openPanna,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _resultBox(
                              "JODI",
                              jodi,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _resultBox(
                              "CLOSE",
                              closePanna,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  ),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(.10),
    borderRadius: BorderRadius.circular(18),
  ),
  child: Row(
    children: [

      Expanded(
        child: Row(
          children: [

            const Icon(
              Icons.schedule_rounded,
              color: Colors.white70,
              size: 18,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                "$openTime • $closeTime",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 10),

      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(.20),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: statusColor.withOpacity(.45),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 6),

            Text(
              status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

const SizedBox(height: 22),

SizedBox(
  width: double.infinity,
  height: 54,
  child: ElevatedButton.icon(
    onPressed: onTap,
    icon: const Icon(
      Icons.bar_chart_rounded,
      size: 20,
    ),
    label: const Text(
      "VIEW RESULT",
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        letterSpacing: .5,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xff6D28D9),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  ),
),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultBox(
    String title,
    String value,
  ) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xff4C1D95),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

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