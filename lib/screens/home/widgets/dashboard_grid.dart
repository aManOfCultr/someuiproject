import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';

bool isDarkMode = false;

class DashboardGrid extends ConsumerWidget {
  final List<GridItem> items;

  const DashboardGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    isDarkMode = themeMode == ThemeMode.dark;
    return GridView.builder(
      physics:
          NeverScrollableScrollPhysics(), // Prevent internal scrolling if used in a parent scrollable view
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 8, // Space between columns
        mainAxisSpacing: 8, // Space between rows
        childAspectRatio: 1, // Square-like grid items
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return DashboardGridItem(
          icon: items[index].icon,
          label: items[index].label,
          onTap: items[index].onTap,
        );
      },
    );
  }
}

class DashboardGridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const DashboardGridItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color:
            isDarkMode ? Pallete.darkgradient1 : Pallete.lightbackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isDarkMode ? Pallete.darkgradient2 : Pallete.gradient1,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  GridItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}
