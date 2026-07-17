import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPopup extends StatefulWidget {
  const ResultPopup({super.key});

  @override
  State<ResultPopup> createState() => _ResultPopupState();
}

class _ResultPopupState extends State<ResultPopup> {
  static const storageKey = "last_seen_result_popup";

  Map<String, dynamic>? _announcement;
  bool _showPopup = false;

  @override
  void initState() {
    super.initState();
    _listenAnnouncement();
  }

  void _listenAnnouncement() {
    FirebaseFirestore.instance
        .collection("announcements")
        .doc("latest")
        .snapshots()
        .listen((snapshot) async {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;

      final popupId =
          "${data["marketId"]}_${data["resultDate"]}";

      final prefs =
          await SharedPreferences.getInstance();

      final lastSeen =
          prefs.getString(storageKey);

      if (popupId == lastSeen) return;

      if (!mounted) return;

      setState(() {
        _announcement = data;
        _showPopup = true;
      });
    });
  }

  Future<void> _closePopup() async {
    if (_announcement != null) {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        storageKey,
        "${_announcement!["marketId"]}_${_announcement!["resultDate"]}",
      );
    }

    if (!mounted) return;

    setState(() {
      _showPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showPopup || _announcement == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "🎉 RESULT DECLARED",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _announcement!["marketName"],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(_announcement!["resultDate"]),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _box(_announcement!["openPanna"]),
                  const SizedBox(width: 12),
                  Text(
                    _announcement!["jodi"],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _box(_announcement!["closePanna"]),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _closePopup,
                  child: const Text("VIEW RESULT"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(String value) {
    return Container(
      width: 70,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}