import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BreakingNewsWidget extends StatelessWidget {
  const BreakingNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("breakingNews")
          .doc("latest")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data =
            snapshot.data!.data() as Map<String, dynamic>;

        final market =
            data["marketName"] ?? "";

        final result =
            data["result"] ?? "";

        final date =
            data["resultDate"] ?? "";

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.campaign_rounded,
                color: Colors.white,
              ),

              const SizedBox(width: 10),

              const Text(
                "BREAKING",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "$market  •  $result  •  $date",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}