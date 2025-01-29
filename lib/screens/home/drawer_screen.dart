import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/authScreen/auth_screen.dart';
import 'package:sbtcustomer/screens/authScreen/splash_screen.dart';
import 'package:sbtcustomer/screens/contactUs/contact_screen.dart';
import 'package:sbtcustomer/screens/dipatchStatusScreen/dispatch_status_screen.dart';
import 'package:sbtcustomer/screens/faqScreen/faq_screen.dart';
import 'package:sbtcustomer/screens/feedback/feedback_screen.dart';
import 'package:sbtcustomer/screens/home/widgets/drawer_item.dart';
import 'package:sbtcustomer/screens/myOrdersScreen/my_order_screen.dart';
import 'package:sbtcustomer/screens/profile/profile_screen.dart';
import 'package:sbtcustomer/screens/settings/settings_screen.dart';
import 'package:sbtcustomer/screens/sampleRequestScreen/sample_request_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/orders.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Orders",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyOrderScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/request.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Sample Request",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SampleRequestScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/dispatch.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Dispatch Status",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DispatchStatusScreen(),
                          ),
                        );
                      }),
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FeedbackScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/contact.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Contact us",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ContactScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/setting.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Settings",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/help.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "FAQ/Help",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FAQScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                      icon: Image.asset(
                        'assets/img/drawer-icons/setting.png',
                        height: 25,
                        width: 25,
                      ),
                      label: "Delete Account",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AuthScreen(),
                          ),
                        );
                      }),
                  DrawerItem(
                    icon: Icon(
                      Icons.logout,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    label: "Logout",
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ),
                        );
                      }
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
