import 'package:flutter/material.dart';

import '../services/market_service.dart';
import '../models/market_model.dart';
class AddMarketScreen extends StatefulWidget {
  final MarketModel? market;

  const AddMarketScreen({
    super.key,
    this.market,
  });

  bool get isEdit => market != null;

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

  if (widget.market != null) {
    final market = widget.market!;

    _nameController.text = market.name;
    _slugController.text = market.slug;

    _openTimeController.text = market.openTime;
    _closeTimeController.text = market.closeTime;

    _displayOrderController.text =
        market.displayOrder.toString();

    _sortOrderController.text =
        market.sortOrder.toString();

    _viewerController.text =
        market.viewers.toString();

    _isActive = market.isActive;
    _isFeatured = market.isFeatured;
    _favorite = market.favorite;
  }
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

  final hour = picked.hourOfPeriod == 0
      ? 12
      : picked.hourOfPeriod;

  final minute =
      picked.minute.toString().padLeft(2, '0');

  final period =
      picked.period == DayPeriod.am ? "AM" : "PM";

  controller.text =
      "${hour.toString().padLeft(2, '0')}:$minute $period";
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

    if (widget.isEdit) {
  await _marketService.updateMarket(
    marketId: widget.market!.id,
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
} else {
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
}

    if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      widget.isEdit
          ? "✅ Market Updated Successfully"
          : "✅ Market Added Successfully",
    ),
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
Widget _settingTile({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    decoration: BoxDecoration(
      color: const Color(0xffF8FAFC),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: const Color(0xffE5E7EB),
      ),
    ),
    child: Row(
      children: [

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

            ],
          ),
        ),

        Switch(
          value: value,
          onChanged: onChanged,
        ),

      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  elevation: 0,
  centerTitle: false,
  titleSpacing: 20,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Text(
        widget.isEdit
            ? "Edit Market"
            : "Add Market",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),

      const SizedBox(height: 2),

      Text(
        widget.isEdit
            ? "Update market information"
            : "Create a new market",
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),

    ],
  ),
),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              Container(
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xff7C3AED),
        Color(0xff9333EA),
      ],
    ),
    borderRadius: BorderRadius.circular(22),
  ),
  child: const Row(
    children: [

      Icon(
        Icons.storefront_rounded,
        color: Colors.white,
        size: 32,
      ),

      SizedBox(width: 16),

     Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Text(
        
        
             "Market Information",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),

      const SizedBox(height: 4),

      Text(
        
            
             "Enter the basic market details",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),

    ],
  ),
),
    ],
  ),
),

const SizedBox(height:24),

        TextFormField(
  controller: _nameController,
  validator: _requiredValidator,
  textCapitalization: TextCapitalization.words,
  decoration: InputDecoration(
    labelText: "Market Name",
    hintText: "Enter market name",
    prefixIcon: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.storefront_rounded,
        color: Colors.deepPurple,
      ),
    ),
  ),
),

              const SizedBox(height: 18),

   TextFormField(
  controller: _slugController,
  validator: _requiredValidator,
  decoration: InputDecoration(
    labelText: "Slug",
    hintText: "market-slug",
    prefixIcon: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.link_rounded,
        color: Colors.blue,
      ),
    ),
  ),
),

              const SizedBox(height: 18),
TextFormField(
  controller: _openTimeController,
  validator: _requiredValidator,
  readOnly: true,
  onTap: () => _pickTime(_openTimeController),
  decoration: InputDecoration(
    labelText: "Open Time",
    hintText: "Select time",
    prefixIcon: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.schedule_rounded,
        color: Colors.green,
      ),
    ),
    suffixIcon: const Icon(Icons.keyboard_arrow_down),
  ),
),

              const SizedBox(height: 18),

           TextFormField(
  controller: _closeTimeController,
  validator: _requiredValidator,
  readOnly: true,
  onTap: () => _pickTime(_closeTimeController),
  decoration: InputDecoration(
    labelText: "Close Time",
    hintText: "Select time",
    prefixIcon: Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.schedule_rounded,
        color: Colors.red,
      ),
    ),
    suffixIcon: const Icon(Icons.keyboard_arrow_down),
  ),
),

              const SizedBox(height: 18),

             Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: const Color(0xffE5E7EB),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Row(
        children: [

          Icon(
            Icons.tune_rounded,
            color: Colors.deepPurple,
          ),

          SizedBox(width: 10),

          Text(
            "Market Configuration",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

        ],
      ),

      const SizedBox(height: 20),

      Row(
        children: [

          Expanded(
            child: TextFormField(
              controller: _displayOrderController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Display",
                prefixIcon: Icon(Icons.dashboard_customize_rounded),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: TextFormField(
              controller: _sortOrderController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Sort",
                prefixIcon: Icon(Icons.swap_vert_rounded),
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
          prefixIcon: Icon(Icons.visibility_rounded),
        ),
      ),

    ],
  ),
),

const SizedBox(height: 30),

Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: const Color(0xffE5E7EB),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Row(
        children: [

          Icon(
            Icons.settings_rounded,
            color: Colors.deepPurple,
          ),

          SizedBox(width: 10),

          Text(
            "Market Settings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

        ],
      ),

      const SizedBox(height: 20),

      _settingTile(
        icon: Icons.check_circle_rounded,
        color: Colors.green,
        title: "Active Market",
        subtitle: "Visible to users",
        value: _isActive,
        onChanged: (v) {
          setState(() => _isActive = v);
        },
      ),

      const SizedBox(height: 14),

      _settingTile(
        icon: Icons.star_rounded,
        color: Colors.orange,
        title: "Featured Market",
        subtitle: "Highlight on home page",
        value: _isFeatured,
        onChanged: (v) {
          setState(() => _isFeatured = v);
        },
      ),

      const SizedBox(height: 14),

      _settingTile(
        icon: Icons.favorite_rounded,
        color: Colors.red,
        title: "Favorite Market",
        subtitle: "Mark as favourite",
        value: _favorite,
        onChanged: (v) {
          setState(() => _favorite = v);
        },
      ),

    ],
  ),
),

const SizedBox(height: 35),
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: const Color(0xffE5E7EB),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.04),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Row(
    children: [

      Expanded(
        child: OutlinedButton.icon(
          onPressed: _saving
              ? null
              : () {
                  Navigator.pop(context);
                },
          icon: const Icon(Icons.close_rounded),
          label: const Text("Cancel"),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(
              double.infinity,
              56,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18),
            ),
          ),
        ),
      ),

      const SizedBox(width: 16),

      Expanded(
        flex: 2,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xff7C3AED),
                Color(0xff9333EA),
              ],
            ),
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple
                    .withOpacity(.30),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FilledButton.icon(
            onPressed:
                _saving ? null : _saveMarket,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.check_circle_rounded,
                  ),
            label:Text(
  _saving
      ? (widget.isEdit
            ? "Updating..."
            : "Saving...")
      : (widget.isEdit
            ? "Update Market"
            : "Save Market"),
),
            style: FilledButton.styleFrom(
              backgroundColor:
                  Colors.transparent,
              shadowColor: Colors.transparent,
              minimumSize: const Size(
                double.infinity,
                56,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),

    ],
  ),
),

const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}