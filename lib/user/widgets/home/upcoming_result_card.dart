import 'package:flutter/material.dart';

class UpcomingResultCard extends StatelessWidget {
  final String marketName;
  final Widget countdown;
  final String status;
  final String openTime;
  final String closeTime;
  final Color color;
  final VoidCallback onTap;

  const UpcomingResultCard({
    super.key,
    required this.marketName,
    required this.countdown,
    required this.status,
    required this.openTime,
    required this.closeTime,
    required this.color,
    required this.onTap,
  });

  IconData _statusIcon() {
    switch (status.toLowerCase()) {
      case "completed":
        return Icons.check_circle_rounded;

      case "open due":
        return Icons.schedule_rounded;

      case "close due":
        return Icons.flag_circle_rounded;

      case "open overdue":
      case "close overdue":
      case "overdue":
        return Icons.warning_rounded;

      default:
        return Icons.access_time_filled_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _statusIcon(),
                  color: color,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      marketName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(.12),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          "$openTime • $closeTime",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              DefaultTextStyle(
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
                child: countdown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}