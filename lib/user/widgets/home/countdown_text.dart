import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/countdown_utils.dart';

class CountdownText extends StatefulWidget {
  final String openTime;
  final String closeTime;
  final Map<String, dynamic>? todayResult;

  const CountdownText({
    super.key,
    required this.openTime,
    required this.closeTime,
    required this.todayResult,
  });

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = getNextMarketEvent(
      openTime: widget.openTime,
      closeTime: widget.closeTime,
      todayResult: widget.todayResult,
    );

    if (event.completed) {
      return const Text(
        "--:--:--",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Text(
      formatDuration(event.remaining),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}