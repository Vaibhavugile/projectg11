import 'package:flutter/material.dart';
import '../models/market_model.dart';
import '../services/market_service.dart';
import '../services/result_service.dart';

class ManageResultScreen extends StatefulWidget {
  final String marketId;

  const ManageResultScreen({
    super.key,
    required this.marketId,
  });

  @override
  State<ManageResultScreen> createState() =>
      _ManageResultScreenState();
}

class _ManageResultScreenState
    extends State<ManageResultScreen> {

  bool _loading = true;
String _marketName = "";
final MarketService _marketService =
    MarketService();

final ResultService _resultService =
    ResultService();

MarketModel? _market;

Map<String, dynamic>? _todayResult;
String _openTime = "";

String _closeTime = "";

bool _hasStartedResult = false;

String _selectedTab = "open";
bool _saving = false;
final TextEditingController _openPannaController =
    TextEditingController();

final TextEditingController _openAnkController =
    TextEditingController();

final TextEditingController _closePannaController =
    TextEditingController();

final TextEditingController _closeAnkController =
    TextEditingController();

final TextEditingController _jodiController =
    TextEditingController();
  @override
  void initState() {
    super.initState();

    _loadData();
  }
  @override
void dispose() {
  _openPannaController.dispose();
  _openAnkController.dispose();
  _closePannaController.dispose();
  _closeAnkController.dispose();
  _jodiController.dispose();

  super.dispose();
}

  Future<void> _loadData() async {
  try {
    setState(() {
      _loading = true;
    });

    /// Load Market

    final market =
        await _marketService.getMarket(
      widget.marketId,
    );

    if (market == null) {
      if (!mounted) return;

      Navigator.pop(context);

      return;
    }

    /// Load Today's Result

    final todayResult =
        await _resultService.getTodayResult(
      widget.marketId,
    );

    _market = market;

    _todayResult = todayResult;

    _marketName = market.name;

    _openTime = market.openTime;

    _closeTime = market.closeTime;

    if (todayResult != null) {
      _openPannaController.text =
          todayResult["openPanna"] ?? "";

      _openAnkController.text =
          todayResult["openAnk"] ?? "";

      _closePannaController.text =
          todayResult["closePanna"] ?? "";

      _closeAnkController.text =
          todayResult["closeAnk"] ?? "";

      _jodiController.text =
          todayResult["jodi"] ?? "";

      _hasStartedResult =
          (todayResult["openPanna"] ?? "")
              .toString()
              .isNotEmpty;

      if (_hasStartedResult) {
        _selectedTab = "close";
      }
    }

    if (!mounted) return;

    setState(() {});
  } catch (e) {
    debugPrint(e.toString());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }
}
  String _calculateAnk(String panna) {
  if (panna.length != 3) {
    return "";
  }

  final total = panna
      .split("")
      .map(int.parse)
      .reduce((a, b) => a + b);

  return (total % 10).toString();
}

String _calculateJodi(
  String openAnk,
  String closeAnk,
) {
  if (openAnk.isEmpty ||
      closeAnk.isEmpty) {
    return "";
  }

  return "$openAnk$closeAnk";
}
Future<void> _saveOpenResult() async {
  if (_market == null) return;

  if (_openPannaController.text.length != 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Enter a valid Open Panna",
        ),
      ),
    );
    return;
  }

  try {
    setState(() {
      _saving = true;
    });

    /// 1. Save Result

    await _resultService.saveOpenResult(
      marketId: _market!.id,
      marketName: _market!.name,
      openPanna: _openPannaController.text,
      openAnk: _openAnkController.text,
    );

    /// 2. Update Latest Result

    await _resultService.updateMarketLatestResult(
      marketId: _market!.id,
      latestResult: {
        "openPanna": _openPannaController.text,
        "openAnk": _openAnkController.text,
        "closePanna": "",
        "closeAnk": "",
        "jodi": "",
        "resultDate": _resultService.today,
      },
    );

    /// 3. Announcement

    await _resultService.updateAnnouncement(
      marketId: _market!.id,
      marketName: _market!.name,
      openPanna: _openPannaController.text,
      jodi: "",
      closePanna: "",
    );

    /// 4. Breaking News

    await _resultService.updateBreakingNews(
      marketId: _market!.id,
      marketName: _market!.name,
      openPanna: _openPannaController.text,
      jodi: "",
      closePanna: "",
    );

    /// 5. Panel Chart

    await _resultService.updatePanelChart(
      marketId: _market!.id,
      openPanna: _openPannaController.text,
      jodi: "",
      closePanna: "",
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Open Result Saved Successfully",
        ),
      ),
    );

    await _loadData();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
    if (!mounted) return;

    setState(() {
      _saving = false;
    });
  }
}
Future<void> _saveCloseResult() async {
  if (_market == null) return;

  if (_closePannaController.text.length != 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Enter a valid Close Panna",
        ),
      ),
    );
    return;
  }

  try {
    setState(() {
      _saving = true;
    });

    /// 1. Save Close Result

    await _resultService.saveCloseResult(
      marketId: _market!.id,
      closePanna: _closePannaController.text,
      closeAnk: _closeAnkController.text,
      jodi: _jodiController.text,
    );

    /// 2. Update Latest Result

    await _resultService.updateMarketLatestResult(
      marketId: _market!.id,
      latestResult: {
        "openPanna": _openPannaController.text,
        "openAnk": _openAnkController.text,
        "closePanna": _closePannaController.text,
        "closeAnk": _closeAnkController.text,
        "jodi": _jodiController.text,
        "resultDate": _resultService.today,
      },
    );

    /// 3. Update Announcement

    await _resultService.updateAnnouncement(
      marketId: _market!.id,
      marketName: _market!.name,
      openPanna: _openPannaController.text,
      jodi: _jodiController.text,
      closePanna: _closePannaController.text,
    );

    /// 4. Update Breaking News

    await _resultService.updateBreakingNews(
      marketId: _market!.id,
      marketName: _market!.name,
      openPanna: _openPannaController.text,
      jodi: _jodiController.text,
      closePanna: _closePannaController.text,
    );

    /// 5. Update Weekly Panel Chart

    await _resultService.updatePanelChart(
      marketId: _market!.id,
      openPanna: _openPannaController.text,
      jodi: _jodiController.text,
      closePanna: _closePannaController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Close Result Saved Successfully",
        ),
      ),
    );

    await _loadData();
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
    if (!mounted) return;

    setState(() {
      _saving = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {

    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(
  _marketName.isEmpty
      ? "Manage Result"
      : "Manage Result • $_marketName",
),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            /// Header

            Text(
  _marketName,
  style: const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
),

            const SizedBox(height: 6),

            Text(
              "Manage today's market result",
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 25),

            /// Market Info Card

           Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                "OPEN TIME",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _openTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                "CLOSE TIME",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _closeTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                "STATUS",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _hasStartedResult
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  _hasStartedResult
                      ? "Result Started"
                      : "Waiting For Open",
                  style: TextStyle(
                    color: _hasStartedResult
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

            SizedBox(height: 25),

            /// Toggle

            Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [

        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              setState(() {
                _selectedTab = "open";
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor:
                  _selectedTab == "open"
                      ? Colors.green
                      : Colors.grey.shade300,
              foregroundColor:
                  _selectedTab == "open"
                      ? Colors.white
                      : Colors.black,
            ),
            icon: const Icon(Icons.circle),
            label: const Text(
              "Open Result",
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: FilledButton.icon(
            onPressed: _hasStartedResult
                ? () {
                    setState(() {
                      _selectedTab = "close";
                    });
                  }
                : null,
            style: FilledButton.styleFrom(
              backgroundColor:
                  _selectedTab == "close"
                      ? Colors.red
                      : Colors.grey.shade300,
              foregroundColor:
                  _selectedTab == "close"
                      ? Colors.white
                      : Colors.black,
            ),
            icon: Icon(
              _hasStartedResult
                  ? Icons.lock_open
                  : Icons.lock,
            ),
            label: Text(
              _hasStartedResult
                  ? "Close Result"
                  : "Locked",
            ),
          ),
        ),

      ],
    ),
  ),
),

            SizedBox(height: 25),

            /// Result Form

          Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Padding(
    padding: const EdgeInsets.all(22),
    child: _selectedTab == "open"
        ? Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "🟢 Open Result",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

             TextField(
  controller: _openPannaController,
  keyboardType: TextInputType.number,
  maxLength: 3,
  decoration: const InputDecoration(
    labelText: "Open Panna",
    prefixIcon: Icon(Icons.grid_view),
  ),
  onChanged: (value) {

    final numbers =
        value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers != value) {
      _openPannaController.value =
          TextEditingValue(
        text: numbers,
        selection: TextSelection.collapsed(
          offset: numbers.length,
        ),
      );
    }

    final ank =
        _calculateAnk(numbers);

    _openAnkController.text = ank;

    _jodiController.text =
        _calculateJodi(
      ank,
      _closeAnkController.text,
    );
  },
),

              const SizedBox(height: 20),

              TextField(
                controller:
                    _openAnkController,
                readOnly: true,
                decoration:
                    const InputDecoration(
                  labelText: "Open Ank",
                  prefixIcon:
                      Icon(Icons.calculate),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                 onPressed: _saving ? null : _saveOpenResult,
                  icon: const Icon(Icons.save),
                  label: Text(
  _saving
      ? "Saving..."
      : "Save Open Result",
),
                ),
              ),

            ],
          )
        : Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const Text(
                "🔴 Close Result",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),
TextField(
  controller: _openPannaController,
  readOnly: true,
  decoration: const InputDecoration(
    labelText: "Open Panna",
    prefixIcon: Icon(Icons.lock),
  ),
),
const SizedBox(height: 20),

TextField(
  controller: _openAnkController,
  readOnly: true,
  decoration: const InputDecoration(
    labelText: "Open Ank",
    prefixIcon: Icon(Icons.calculate),
  ),
),
              const SizedBox(height: 20),

              TextField(
  controller: _closePannaController,
  keyboardType: TextInputType.number,
  maxLength: 3,
  decoration: const InputDecoration(
    labelText: "Close Panna",
  ),
  onChanged: (value) {

    final numbers =
        value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers != value) {
      _closePannaController.value =
          TextEditingValue(
        text: numbers,
        selection: TextSelection.collapsed(
          offset: numbers.length,
        ),
      );
    }

    final ank =
        _calculateAnk(numbers);

    _closeAnkController.text = ank;

    _jodiController.text =
        _calculateJodi(
      _openAnkController.text,
      ank,
    );
  },
),

              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller:
                          _closeAnkController,
                      readOnly: true,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Close Ank",
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: TextField(
                      controller:
                          _jodiController,
                      readOnly: true,
                      decoration:
                          const InputDecoration(
                        labelText: "Jodi",
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving
    ? null
    : _saveCloseResult,
                  icon: const Icon(Icons.save),
                 label: Text(
  _saving
      ? "Saving..."
      : "Save Close Result",
),
                ),
              ),

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