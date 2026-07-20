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

                /// FEATURED BADGE
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white24,
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

                        SizedBox(width: 8),

                        Text(
                          "FEATURED MARKET",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// MARKET NAME
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

                const SizedBox(height: 8),

                Text(
                  "Today's Featured Result",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.80),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 26),

                /// COUNTDOWN LABEL
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 16,
                      ),

                      SizedBox(width: 6),

                      Text(
                        "LIVE COUNTDOWN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// COUNTDOWN
                CountdownRing(
                  progress: 0.72, // TODO: Replace with real progress
                  color: Colors.white,
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

                const SizedBox(height: 26),

                // -------- PART 2 STARTS FROM HERE --------
                /// STATUS CHIP
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 8,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(40),
  ),
  child: Text(
    status.toUpperCase(),
    style: TextStyle(
      color: color,
      fontWeight: FontWeight.w800,
      fontSize: 13,
      letterSpacing: .8,
    ),
  ),
),

const SizedBox(height: 28),

/// OPEN / CLOSE
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

const SizedBox(height: 24),

/// FOOTER
Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 16,
  ),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(.12),
    borderRadius: BorderRadius.circular(22),
  ),
  child: Row(
    children: [

      const Icon(
        Icons.touch_app_rounded,
        color: Colors.white,
        size: 20,
      ),

      const SizedBox(width: 10),

      const Expanded(
        child: Text(
          "Tap to View Live Result",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),

      Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: color,
          size: 22,
        ),
      ),
    ],
  ),
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
      vertical: 18,
      horizontal: 12,
    ),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.12),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: Colors.white24,
      ),
    ),
    child: Column(
      children: [

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.14),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ],
    ),
  );
}
}