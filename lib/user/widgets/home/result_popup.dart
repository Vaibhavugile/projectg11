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

  return Material(
    color: Colors.black.withOpacity(.72),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff6A11CB),
                Color(0xff2575FC),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(.45),
                blurRadius: 35,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: _closePopup,
                      borderRadius: BorderRadius.circular(30),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.15),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "RESULT DECLARED",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _announcement!["marketName"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _announcement!["resultDate"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Expanded(
                        child: _premiumBox(
                          _announcement!["openPanna"],
                          "OPEN",
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [

                            const Text(
                              "JODI",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              _announcement!["jodi"],
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: _premiumBox(
                          _announcement!["closePanna"],
                          "CLOSE",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _closePopup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "VIEW RESULT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _premiumBox(String value, String title) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.15),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: Colors.white30,
      ),
    ),
    child: Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ],
    ),
  );
}
}