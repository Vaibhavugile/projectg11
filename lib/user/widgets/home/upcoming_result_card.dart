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
        return Icons.warning_amber_rounded;

      default:
        return Icons.access_time_filled_rounded;
    }
  }
@override
Widget build(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.deepPurple.shade50,
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

            /// LEFT
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [

                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: color.withOpacity(.12),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.hourglass_top,
                          color: color,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          marketName,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [

                      Container(
                        width: 9,
                        height: 9,
                        decoration:
                            const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 2,
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          color: Colors.grey.shade300,
                        ),
                      ),

                      Container(
                        width: 9,
                        height: 9,
                        decoration:
                            const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              openTime,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              "OPEN",
                              style: TextStyle(
                                color:
                                    Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [

                            Text(
                              closeTime,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 2),
                            Text(
  "CLOSE",
  style: TextStyle(
    color: Colors.grey.shade600,
    fontSize: 11,
  ),
),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            /// RIGHT SIDE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Icon(
                        _statusIcon(),
                        size: 14,
                        color: color,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                DefaultTextStyle(
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: 1,
                  ),
                  child: countdown,
                ),

                const SizedBox(height: 4),

                Text(
                  "Starts In",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}