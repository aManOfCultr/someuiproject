import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/auth/auth_screen.dart';
import 'package:sbtcustomer/screens/home/widgets/drawer_item.dart';

class DrawerScreen extends ConsumerWidget {
  final String userName;
  final String email;

  const DrawerScreen({super.key, required this.userName, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    return SafeArea(
      child: Drawer(
        elevation: 0,
        child: Column(
          children: [
            // Drawer Header
            SafeArea(
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person,
                          size: 40, color: Pallete.gradient1),
                    ),
                    SizedBox(width: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ])
                  ],
                ),
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItem(
                      icon: Icon(
                        Icons.dashboard_outlined,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      label: "Dashboard",
                      onTap: () {}),
                  DrawerItem(
                      icon: Icon(
                        Icons.person,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      label: "Profile",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/orders.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Orders",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/request.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Sample Request",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/dispatch.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Dispatch Status",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/payment.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Payment Dues",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/feedback.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Feedback",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/contact.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Contact us",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/setting.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Settings",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/help.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "FAQ/Help",
                      onTap: () {}),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/setting.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Delete Account",
                      onTap: () {}),
                  DrawerItem(
                    icon: Icon(
                      Icons.logout,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    label: "Logout",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
