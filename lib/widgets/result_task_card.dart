import 'package:flutter/material.dart';

import '../models/market_model.dart';
import '../utils/result_utils.dart';

class ResultTaskCard extends StatelessWidget {
  final int index;

  final MarketModel market;

  final String latestResult;

  final MarketStatus status;

  final VoidCallback onTap;

  const ResultTaskCard({
    super.key,
    required this.index,
    required this.market,
    required this.latestResult,
    required this.status,
    required this.onTap,
  });

 @override
Widget build(BuildContext context) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(28),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      splashColor: Colors.deepPurple.withOpacity(.08),
      highlightColor: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffffffff),
      Color(0xfffcfcff),
    ],
  ),
  border: Border.all(
    color: const Color(0xffECEFF5),
    width: 1.2,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(.03),
      blurRadius: 40,
      spreadRadius: 3,
      offset: const Offset(0, 18),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(.9),
      blurRadius: 12,
      offset: const Offset(-2, -2),
    ),
  ],
),
        child: Row(
          children: [

            _buildAccentBar(),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    /// Header
                    _buildHeader(),

                    const SizedBox(height: 12),

                    /// Result
                    _buildResultSection(),

                    const SizedBox(height: 12),

                    /// Footer
                    _buildFooter(),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

Widget _buildAccentBar() {
  List<Color> colors;

  switch (status.badge) {
    case "overdue":
      colors = const [
        Color(0xffEF4444),
        Color(0xffDC2626),
      ];
      break;

    case "due":
      colors = const [
        Color(0xffF59E0B),
        Color(0xffEA580C),
      ];
      break;

    case "completed":
      colors = const [
        Color(0xff10B981),
        Color(0xff059669),
      ];
      break;

    default:
      colors = const [
        Color(0xff6366F1),
        Color(0xff8B5CF6),
      ];
  }

  return Container(
    width: 8,
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: colors.first.withOpacity(.35),
          blurRadius: 18,
          spreadRadius: 2,
        ),
      ],
    ),
  );
}
Widget _buildHeader() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      // Premium Number Avatar
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff7C3AED),
              Color(0xff9333EA),
            ],
          ),
          border: Border.all(
  color: Colors.white,
  width: 2,
),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff7C3AED)
                  .withOpacity(.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "${index + 1}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),

      const SizedBox(width: 16),

      Expanded(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              market.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -.5,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Colors.grey.shade600,
                ),

                const SizedBox(width: 6),

                Text(
                  "${market.openTime} → ${market.closeTime}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),

          ],
        ),
      ),

      _buildPriorityChip(),

    ],
  );
}
Widget _buildPriorityChip() {
  late List<Color> colors;
  late IconData icon;

  switch (status.priorityText) {
    case "HIGH":
      colors = const [
        Color(0xffEF4444),
        Color(0xffDC2626),
      ];
      icon = Icons.local_fire_department_rounded;
      break;

    case "MEDIUM":
      colors = const [
        Color(0xffF59E0B),
        Color(0xffEA580C),
      ];
      icon = Icons.flash_on_rounded;
      break;

    case "DONE":
      colors = const [
        Color(0xff10B981),
        Color(0xff059669),
      ];
      icon = Icons.check_circle_rounded;
      break;

    default:
      colors = const [
        Color(0xff6366F1),
        Color(0xff8B5CF6),
      ];
      icon = Icons.schedule_rounded;
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: colors.first.withOpacity(.35),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),

        const SizedBox(width: 6),

        Text(
          status.priorityText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: .5,
          ),
        ),

      ],
    ),
  );
}
Widget _buildResultSection() {
  final parts = latestResult.split("-");

  final open =
      parts.isNotEmpty ? parts[0].trim() : "***";

  final jodi =
      parts.length > 1 ? parts[1].trim() : "**";

  final close =
      parts.length > 2 ? parts[2].trim() : "***";

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 16,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffFCFCFF),
          Color(0xffF3F6FF),
        ],
      ),
      border: Border.all(
        color: const Color(0xffE9EEF8),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurple.withOpacity(.04),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xff7C3AED),
                Color(0xff9333EA),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.casino_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "TODAY'S RESULT",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff64748B),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  _resultBox(open),

                  const SizedBox(width: 8),

                  _resultBox(jodi),

                  const SizedBox(width: 8),

                  _resultBox(close),

                ],
              ),

            ],
          ),
        ),

      ],
    ),
  );
}
Widget _resultBox(String value) {
  return Expanded(
    child: Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE5E7EB),
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    ),
  );
}
Widget _buildFooter() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      Expanded(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            _buildStatusChip(),

const SizedBox(height: 10),

Text(
  status.description,
  style: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Color(0xff64748B),
    height: 1.4,
  ),
),

          ],
        ),
      ),

      const SizedBox(width: 16),

      _buildActionButton(),

    ],
  );
}
Widget _buildStatusChip() {
  late List<Color> colors;
  late IconData icon;

  switch (status.badge) {
    case "overdue":
      colors = const [
        Color(0xffEF4444),
        Color(0xffDC2626),
      ];
      icon = Icons.warning_rounded;
      break;

    case "due":
      colors = const [
        Color(0xffF59E0B),
        Color(0xffEA580C),
      ];
      icon = Icons.access_time_filled_rounded;
      break;

    case "completed":
      colors = const [
        Color(0xff10B981),
        Color(0xff059669),
      ];
      icon = Icons.check_circle_rounded;
      break;

    default:
      colors = const [
        Color(0xff6366F1),
        Color(0xff8B5CF6),
      ];
      icon = Icons.schedule_rounded;
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 9,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: colors.first.withOpacity(.30),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),

        const SizedBox(width: 6),

        Text(
          status.status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: .3,
          ),
        ),

      ],
    ),
  );
}

Widget _buildActionButton() {
  late List<Color> colors;

  switch (status.badge) {
    case "overdue":
      colors = const [
        Color(0xffEF4444),
        Color(0xffDC2626),
      ];
      break;

    case "due":
      colors = const [
        Color(0xffF59E0B),
        Color(0xffEA580C),
      ];
      break;

    case "completed":
      colors = const [
        Color(0xff10B981),
        Color(0xff059669),
      ];
      break;

    default:
      colors = const [
        Color(0xff7C3AED),
        Color(0xff5B21B6),
      ];
  }

  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: colors.first.withOpacity(.30),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                status.action,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),

            ],
          ),
        ),
      ),
    ),
  );
}
}