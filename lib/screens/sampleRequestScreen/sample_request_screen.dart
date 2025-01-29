import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/core/widgets/gradient_button.dart';

class SampleRequestScreen extends ConsumerStatefulWidget {
  const SampleRequestScreen({super.key});

  @override
  ConsumerState<SampleRequestScreen> createState() => _SampleRequestScreenState();
}

class _SampleRequestScreenState extends ConsumerState<SampleRequestScreen> {
  bool isRequestSelected = true;
  String? selectedProduct;
  final List<String> products = ["Product A", "Product B", "Product C"];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        title: Text(
          'Sample Request',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              isDarkMode ? 'assets/img/dark-footer.png' : 'assets/img/footer.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Segmented Buttons - Centered and Full Width
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isRequestSelected = true),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isRequestSelected
                                  ? (isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Request',
                              style: TextStyle(
                                color: isRequestSelected ? Colors.white : textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isRequestSelected = false),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isRequestSelected
                                  ? (isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Track',
                              style: TextStyle(
                                color: !isRequestSelected ? Colors.white : textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Product Name', style: TextStyle(fontSize: 18, color: textColor)),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient2,
                      hint: Text('Select Product', style: TextStyle(color: textColor)),
                      value: selectedProduct,
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                        });
                      },
                      items: products.map((product) {
                        return DropdownMenuItem(
                          
                          value: product,
                          child: Text(product, style: TextStyle(color: textColor)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Description', style: TextStyle(fontSize: 18, color: textColor)),
                SizedBox(height: 5),
                TextField(
                  maxLines: 5,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                GradientButton(buttonName: 'Submit', onTap: () {
                  
                },)
              //   SizedBox(
              //     width: double.infinity,
              //     height: 50,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Pallete.gradient1,
              //       ),
              //       onPressed: () {},
              //       child: Text(
              //         'SUBMIT',
              //         style: TextStyle(color: Colors.white, fontSize: 18),
              //       ),
              //     ),
              //   ),
               ],
            ),
          ),
        ],
      ),
    );
  }
}
