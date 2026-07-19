import 'package:flutter/material.dart';
import 'countdown_ring.dart';
class HeroResultCard extends StatelessWidget {
  final String marketName;
  final Widget countdown;
  final String status;
  final String openTime;
  final String closeTime;
  final Color color;
  final VoidCallback onTap;

  const HeroResultCard({
    super.key,
    required this.marketName,
    required this.countdown,
    required this.status,
    required this.openTime,
    required this.closeTime,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 22),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withOpacity(.90),
                ],
              ),
              border: Border.all(
                color: Colors.white24,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(.35),
                  blurRadius: 35,
                  spreadRadius: 2,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                children: [

                  Row(
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Icon(
                              Icons.workspace_premium,
                              size: 16,
                              color: Colors.white,
                            ),

                            SizedBox(width: 6),

                            Text(
                              "#1 PRIORITY",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
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
                              Icons.circle,
                              size: 9,
                              color: Colors.redAccent,
                            ),

                            SizedBox(width: 6),

                            Text(
                              "LIVE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Text(
                    marketName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(40),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "LIVE COUNTDOWN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                 CountdownRing(
  progress: 0.72, // temporary value
  color: color,
  child: DefaultTextStyle(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 34,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
    ),
    child: countdown,
  ),
),

                  const SizedBox(height: 28),

                  Row(
                    children: [

                      Expanded(
                        child: _timeBox(
                          Icons.lock_open_rounded,
                          "OPEN",
                          openTime,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _timeBox(
                          Icons.flag_rounded,
                          "CLOSE",
                          closeTime,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeBox(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}