import 'package:flutter/material.dart';
import '../screens/manage_result_screen.dart';
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.deepPurple.withOpacity(.08),
        highlightColor: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffffffff),
                Color(0xffFCFCFF),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xffECEFF5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 14),
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
                      _buildHeader(),

                      const SizedBox(height: 14),

                      _buildTimeSection(),

                      const SizedBox(height: 14),

                      _buildResultSection(),

                      const SizedBox(height: 14),

                      _buildFooter(context),
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
  final colors = market.isActive
      ? const [
          Color(0xff10B981),
          Color(0xff059669),
        ]
      : const [
          Color(0xffEF4444),
          Color(0xffDC2626),
        ];

  return Container(
    width: 8,
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ),
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
Widget _buildStatusChip() {
  final active = market.isActive;

  final colors = active
      ? const [
          Color(0xff10B981),
          Color(0xff059669),
        ]
      : const [
          Color(0xffEF4444),
          Color(0xffDC2626),
        ];

  final icon = active
      ? Icons.check_circle_rounded
      : Icons.cancel_rounded;

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
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
          size: 15,
        ),

        const SizedBox(width: 6),

        Text(
          active ? "ACTIVE" : "INACTIVE",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: .6,
          ),
        ),

      ],
    ),
  );
}
Widget _buildTimeSection() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    decoration: BoxDecoration(
      color: const Color(0xffF8FAFC),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xffE7ECF3),
      ),
    ),
    child: Row(
      children: [

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.schedule_rounded,
            color: Colors.deepPurple,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "MARKET TIMING",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: Color(0xff64748B),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "${market.openTime}  →  ${market.closeTime}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

            ],
          ),
        ),

      ],
    ),
  );
}

 Widget _buildHeader() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff7C3AED),
              Color(0xff9333EA),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff7C3AED).withOpacity(.30),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            index.toString().padLeft(2, "0"),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),

      const SizedBox(width: 16),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              market.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -.4,
                color: Color(0xff111827),
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [

                Icon(
                  Icons.tag_rounded,
                  size: 15,
                  color: Colors.grey.shade500,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    market.slug,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),

      const SizedBox(width: 12),

      _buildStatusChip(),

    ],
  );
}


  Widget _buildResultSection() {
  final latest = market.latestResult;

  final open =
      latest?["openPanna"]?.toString() ?? "***";

  final jodi =
      latest?["jodi"]?.toString() ?? "**";

  final close =
      latest?["closePanna"]?.toString() ?? "***";

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 16,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
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
          color: Colors.deepPurple.withOpacity(.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Row(
          children: [

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff7C3AED),
                    Color(0xff9333EA),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.casino_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              "LATEST RESULT",
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                color: Color(0xff64748B),
              ),
            ),

          ],
        ),

        const SizedBox(height: 16),

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
Widget _buildFooter(BuildContext context) {
  return Column(
    children: [

      Row(
        children: [

          if (market.isFeatured)
            _buildChip(
              Icons.star_rounded,
              "Featured",
              const Color(0xffF59E0B),
            ),

          if (market.isFeatured)
            const SizedBox(width: 10),

          if (market.favorite)
            _buildChip(
              Icons.favorite_rounded,
              "Favorite",
              const Color(0xffEF4444),
            ),

          const Spacer(),

          Icon(
            Icons.visibility_outlined,
            size: 18,
            color: Colors.grey.shade600,
          ),

          const SizedBox(width: 6),

          Text(
            market.viewers.toString(),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),

        ],
      ),

      const SizedBox(height: 18),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _actionButton(
            Icons.edit_rounded,
            "Edit",
            Colors.blue,
            onTap: () {
              // TODO: Edit Market
            },
          ),

          _actionButton(
            Icons.bar_chart_rounded,
            "Result",
            Colors.deepPurple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManageResultScreen(
                    marketId: market.id,
                  ),
                ),
              );
            },
          ),

          _actionButton(
            Icons.history_rounded,
            "History",
            Colors.orange,
            onTap: () {
              // TODO: History
            },
          ),

          _actionButton(
            Icons.delete_rounded,
            "Delete",
            Colors.red,
            onTap: () {
              // TODO: Delete
            },
          ),

        ],
      ),

    ],
  );
}
Widget _buildChip(
  IconData icon,
  String text,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 7,
    ),
    decoration: BoxDecoration(
      color: color.withOpacity(.08),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        Icon(
          icon,
          size: 16,
          color: color,
        ),

        const SizedBox(width: 5),

        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),

      ],
    ),
  );
}
Widget _actionButton(
  IconData icon,
  String label,
  Color color, {
  VoidCallback? onTap,
}) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],
        ),
      ),
    ),
  );
}
}