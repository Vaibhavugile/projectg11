import 'package:flutter/material.dart';

import '../services/market_service.dart';

class AddMarketScreen extends StatefulWidget {
  const AddMarketScreen({super.key});

  @override
  State<AddMarketScreen> createState() =>
      _AddMarketScreenState();
}

class _AddMarketScreenState
    extends State<AddMarketScreen> {
  final _formKey = GlobalKey<FormState>();

  final MarketService _marketService =
      MarketService();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _slugController =
      TextEditingController();

  final TextEditingController _openTimeController =
      TextEditingController();

  final TextEditingController _closeTimeController =
      TextEditingController();

  final TextEditingController _displayOrderController =
      TextEditingController(text: "1");

  final TextEditingController _sortOrderController =
      TextEditingController(text: "1");

  final TextEditingController _viewerController =
      TextEditingController(text: "0");

  bool _isActive = true;

  bool _isFeatured = false;

  bool _favorite = false;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_generateSlug);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    _displayOrderController.dispose();
    _sortOrderController.dispose();
    _viewerController.dispose();

    super.dispose();
  }

  void _generateSlug() {
    final slug = _nameController.text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .replaceAll(' ', '-');

    _slugController.text = slug;
  }
  Future<void> _pickTime(
  TextEditingController controller,
) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked == null) return;

  controller.text = picked.format(context);
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "This field is required";
  }
  return null;
}
Future<void> _saveMarket() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  try {
    setState(() {
      _saving = true;
    });

    await _marketService.addMarket(
      name: _nameController.text.trim(),
      slug: _slugController.text.trim(),
      openTime: _openTimeController.text.trim(),
      closeTime: _closeTimeController.text.trim(),
      displayOrder:
          int.tryParse(_displayOrderController.text) ?? 1,
      sortOrder:
          int.tryParse(_sortOrderController.text) ?? 1,
      viewers:
          int.tryParse(_viewerController.text) ?? 0,
      isActive: _isActive,
      isFeatured: _isFeatured,
      favorite: _favorite,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Market Added Successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  } catch (e) {
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
      _saving = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Market"),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              const Text(
                "Market Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
  controller: _nameController,
  validator: _requiredValidator,
  decoration: const InputDecoration(
    labelText: "Market Name",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.store),
  ),
),

              const SizedBox(height: 18),

              TextFormField(
  controller: _slugController,
  validator: _requiredValidator,
  decoration: const InputDecoration(
    labelText: "Slug",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.link),
  ),
),

              const SizedBox(height: 18),

              TextFormField(
  controller: _openTimeController,
  validator: _requiredValidator,
  readOnly: true,
  onTap: () => _pickTime(_openTimeController),
  decoration: const InputDecoration(
    labelText: "Open Time",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.schedule),
    suffixIcon: Icon(Icons.access_time),
  ),
),

              const SizedBox(height: 18),

             TextFormField(
  controller: _closeTimeController,
  validator: _requiredValidator,
  readOnly: true,
  onTap: () => _pickTime(_closeTimeController),
  decoration: const InputDecoration(
    labelText: "Close Time",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.schedule),
    suffixIcon: Icon(Icons.access_time),
  ),
),

              const SizedBox(height: 18),

              Row(
                children: [

                  Expanded(
                    child: TextFormField(
                      controller:
                          _displayOrderController,
                      keyboardType:
                          TextInputType.number,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Display Order",
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: TextFormField(
                      controller:
                          _sortOrderController,
                      keyboardType:
                          TextInputType.number,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Sort Order",
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _viewerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Initial Viewers",
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.visibility),
                ),
              ),
              const SizedBox(height: 30),

const Divider(),

const SizedBox(height: 25),

const Text(
  "Market Settings",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

Card(
  child: SwitchListTile(
    secondary: const Icon(
      Icons.check_circle,
      color: Colors.green,
    ),
    title: const Text("Active Market"),
    subtitle: const Text(
      "Show this market in the app",
    ),
    value: _isActive,
    onChanged: (value) {
      setState(() {
        _isActive = value;
      });
    },
  ),
),

const SizedBox(height: 12),

Card(
  child: SwitchListTile(
    secondary: const Icon(
      Icons.star,
      color: Colors.orange,
    ),
    title: const Text("Featured Market"),
    subtitle: const Text(
      "Show this market on the home page",
    ),
    value: _isFeatured,
    onChanged: (value) {
      setState(() {
        _isFeatured = value;
      });
    },
  ),
),

const SizedBox(height: 12),

Card(
  child: SwitchListTile(
    secondary: const Icon(
      Icons.favorite,
      color: Colors.red,
    ),
    title: const Text("Favorite Market"),
    subtitle: const Text(
      "Mark this market as favourite",
    ),
    value: _favorite,
    onChanged: (value) {
      setState(() {
        _favorite = value;
      });
    },
  ),
),

const SizedBox(height: 35),
Row(
  children: [

    Expanded(
      child: OutlinedButton(
        onPressed: _saving
            ? null
            : () {
                Navigator.pop(context);
              },
        child: const Text("Cancel"),
      ),
    ),

    const SizedBox(width: 15),

    Expanded(
      child: FilledButton(
        onPressed: _saving ? null : _saveMarket,
        child: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text("Save Market"),
      ),
    ),
  ],
),

const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}