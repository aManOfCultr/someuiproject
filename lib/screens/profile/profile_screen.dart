import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/profile/widget/profile_field.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? Pallete.darkgradient1
            : Pallete.gradient1, // Orange color from your design
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(Icons.menu, color: Colors.white),
        //   onPressed: () {
        //     // Add functionality for menu
        //   },
        // ),
      ),
      body: Stack(
        children: [
          // Footer background design
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ProfileField(
                  icon: Icons.person_outline,
                  label: 'Name',
                  value: 'wes',
                ),
                ProfileField(
                  icon: Icons.contact_phone_outlined,
                  label: 'Contact',
                  value: '9993907710',
                ),
                ProfileField(
                  icon: Icons.apartment_outlined,
                  label: 'Firm Name',
                  value: 'wes',
                ),
                ProfileField(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: 'wes raipur',
                ),
                ProfileField(
                  icon: Icons.tag,
                  label: 'GST',
                  value: '123456789012345',
                ),
                ProfileField(
                  icon: Icons.person,
                  label: 'Contact Person Name',
                  value: 'Yogesh',
                ),
                Text(
                  'For any Changes in profile\nplease contact - 9009387000',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Toggle between light and dark themes
          ref.read(themeNotifierProvider.notifier).setThemeMode(
                themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
              );
        },
        child: const Icon(Icons.brightness_6),
      ),
    );
  }
}
