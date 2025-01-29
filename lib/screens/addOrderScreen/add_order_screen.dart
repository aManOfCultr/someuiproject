import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';

class AddOrderScreen extends ConsumerStatefulWidget {
  const AddOrderScreen({super.key});

  @override
  ConsumerState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends ConsumerState<AddOrderScreen> {
  final Map<String, TextEditingController> controllers = {
    'item': TextEditingController(),
    'width': TextEditingController(),
    'slit': TextEditingController(),
    'quantity': TextEditingController(),
    'pkgSize': TextEditingController(),
    'stamping': TextEditingController(),
    'bag': TextEditingController(),
    'quality': TextEditingController(),
    'mtrRoll': TextEditingController(),
    'pcPacket': TextEditingController(),
    'remark': TextEditingController(),
  };

  String? selectedProduct;
  String? selectedType;
  String? selectedColor;

  final Map<String, List<String>> productFields = {
    'Pv fabrics': ['item', 'width', 'pkgSize', 'slit', 'quantity', 'quality', 'stamping', 'bag', 'remark'],
    'Thermobond': ['width', 'pkgSize', 'slit', 'quantity', 'stamping', 'bag', 'remark'],
    'Imported Paper': ['width', 'mtrRoll', 'pkgSize', 'slit', 'quantity', 'stamping', 'bag', 'remark'],
    'Kurkure': ['slit', 'quantity', 'stamping', 'bag', 'mtrRoll', 'remark'],
    'Yarn': ['slit', 'quantity', 'stamping', 'bag', 'pcPacket', 'remark'],
    'Facemask': ['quantity', 'remark'],
  };

  final Map<String, bool> dropdownFields = {
    'Select Type': true,
    'Select Color': true,
  };

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        title: const Text('Add Order', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown to select product
              DropdownButtonFormField<String>(
                value: selectedProduct,
                onChanged: (value) {
                  setState(() {
                    selectedProduct = value;
                    selectedType = null;
                    selectedColor = null;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Product',
                  hintStyle: TextStyle(color: Colors.grey[700]), // Darker hint text
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: productFields.keys.map((product) {
                  return DropdownMenuItem(value: product, child: Text(product));
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Display dynamically based on selected product
              if (selectedProduct != null)
                ...productFields[selectedProduct!]!.map((field) {
                  if (dropdownFields.keys.contains(field)) {
                    return DropdownButtonFormField<String>(
                      value: field == 'Select Type' ? selectedType : selectedColor,
                      onChanged: (value) {
                        setState(() {
                          if (field == 'Select Type') selectedType = value;
                          if (field == 'Select Color') selectedColor = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: field,
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: (field == 'Select Type' ? ['Type 1', 'Type 2', 'Type 3'] : ['Red', 'Blue', 'Green', 'Yellow'])
                          .map((option) {
                        return DropdownMenuItem(value: option, child: Text(option));
                      }).toList(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: controllers[field],
                      keyboardType: field.contains('width') || field.contains('quantity') || field.contains('slit') || field.contains('mtrRoll')
                          ? TextInputType.number
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText: _getLabelText(field),
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: field == 'remark' ? 3 : 1,
                    ),
                  );
                }).toList(),

              // Add Product & Submit Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Add Product logic
                      },
                      child: const Text('ADD PRODUCT', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Submit logic
                      },
                      child: const Text('SUBMIT', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLabelText(String field) {
    switch (field) {
      case 'item':
        return 'Item';
      case 'width':
        return 'Width (cm)';
      case 'slit':
        return 'Slit (mm)';
      case 'quantity':
        return 'Quantity';
      case 'pkgSize':
        return 'Pkg Size';
      case 'stamping':
        return 'Stamping';
      case 'bag':
        return 'Bag';
      case 'quality':
        return 'Quality';
      case 'mtrRoll':
        return 'Mtr-Roll';
      case 'pcPacket':
        return 'Pc/Packet';
      case 'remark':
        return 'Remarks';
      default:
        return '';
    }
  }
}
