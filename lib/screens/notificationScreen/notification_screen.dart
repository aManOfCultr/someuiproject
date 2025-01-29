import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/addOrderScreen/add_order_screen.dart';

class MyOrderScreen extends ConsumerStatefulWidget {
  const MyOrderScreen({super.key});

  @override
  ConsumerState<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends ConsumerState<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.perm_data_setting_sharp,
              size: 30,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: isDarkMode
                ? Image.asset(
                    'assets/img/dark-footer.png', // Replace with your footer image path
                    fit: BoxFit.cover,
                    height: 100, // Adjust height for the footer
                  )
                : Image.asset(
                    'assets/img/footer.png', // Replace with your footer image path
                    fit: BoxFit.cover,
                    height: 100, // Adjust height for the footer
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        onPressed: () {
          // Toggle between light and dark themes
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddOrderScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: isDarkMode ? Pallete.darkgradient2 : Pallete.gradient2,
        ),
      ),
    );
  }
}
