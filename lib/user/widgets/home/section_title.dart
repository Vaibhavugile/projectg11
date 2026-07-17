import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        12,
      ),
      child: Row(
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          if (actionText != null)

            InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  actionText!,
                  style: TextStyle(
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}