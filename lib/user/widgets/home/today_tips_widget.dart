import 'package:flutter/material.dart';

class TodayTipsWidget extends StatelessWidget {
  const TodayTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xff6D28D9),
              Color(0xff8B5CF6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: const [

                Icon(
                  Icons.tips_and_updates_rounded,
                  color: Colors.amber,
                  size: 26,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "Today's Tips",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 18),

            _tip(
              "Play responsibly and within your limits.",
            ),

            const SizedBox(height: 12),

            _tip(
              "Check today's results before placing your next bet.",
            ),

            const SizedBox(height: 12),

            _tip(
              "Follow only verified market updates from the app.",
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [

                  Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "This app provides market information only. Play responsibly.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _tip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 18,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),

      ],
    );
  }
}