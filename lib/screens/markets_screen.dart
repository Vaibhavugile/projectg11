import 'package:flutter/material.dart';

import '../models/market_model.dart';
import '../services/market_service.dart';
import '../widgets/market_card.dart';
import 'add_market_screen.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final MarketService _marketService = MarketService();

  List<MarketModel> _markets = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMarkets();
  }

  Future<void> _fetchMarkets() async {
    try {
      if (mounted) {
        setState(() {
          _loading = true;
        });
      }

      final markets = await _marketService.fetchMarkets();

      if (!mounted) return;

      setState(() {
        _markets = markets;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _openAddMarket() async {
    final refresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddMarketScreen(),
      ),
    );

    if (refresh == true) {
      _fetchMarkets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Markets",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _fetchMarkets,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: "add_market",
        onPressed: _openAddMarket,
        icon: const Icon(Icons.add),
        label: const Text("Add Market"),
      ),

      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchMarkets,
              child: _markets.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        const Center(
                          child: Icon(
                            Icons.storefront_outlined,
                            size: 70,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            "No Markets Found",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            "Tap 'Add Market' to create your first market.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Text(
                            "Total Markets : ${_markets.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _markets.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: MarketCard(
                                  market: _markets[index],
                                  index: index + 1,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}