import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PremiumAppBar extends StatelessWidget {
  final String greeting;
  final String title;
  final VoidCallback? onNotification;
  final VoidCallback? onMenu;

  const PremiumAppBar({
    super.key,
    required this.greeting,
    required this.title,
    this.onNotification,
    this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            InkWell(
              onTap: onMenu,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(Icons.menu_rounded),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    greeting,
                    style: AppTextStyles.subtitle,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    style: AppTextStyles.heading,
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: onNotification,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Stack(
                  children: [

                    const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 26,
                      ),
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}