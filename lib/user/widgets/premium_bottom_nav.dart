import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PremiumBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const PremiumBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, "Home"),
      (Icons.storefront_rounded, "Markets"),
      (Icons.bar_chart_rounded, "Charts"),
      (Icons.campaign_rounded, "Notice"),
      (Icons.person_rounded, "Profile"),
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = currentIndex == index;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withOpacity(.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      AnimatedScale(
                        duration:
                            const Duration(milliseconds: 250),
                        scale: selected ? 1.15 : 1,
                        child: Icon(
                          items[index].$1,
                          color: selected
                              ? AppColors.primary
                              : Colors.grey,
                          size: 28,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        items[index].$2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}