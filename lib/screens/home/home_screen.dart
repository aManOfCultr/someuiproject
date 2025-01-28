import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/home/drawer_screen.dart';
import 'package:sbtcustomer/screens/home/widgets/dashboard_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    return Scaffold(
      drawer: DrawerScreen(userName: "userName", email: "email"),
      body: Builder(builder: (context) {
        return Stack(
          children: [
            // Header Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                isDarkMode
                    ? 'assets/img/dark-headerBg.png'
                    : 'assets/img/headerBg2.png',
                fit: BoxFit.cover,
                height: 150, // Adjust height for the header
              ),
            ),
            // Footer Image
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
            // main body
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            isDarkMode
                                ? const Image(
                                    height: 45,
                                    image: AssetImage(
                                        'assets/img/new_sbt_dark_logo.png'),
                                  )
                                : const Image(
                                    height: 45,
                                    image:
                                        AssetImage('assets/img/sbt-logo2.png'),
                                  ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: isDarkMode
                                    ? Pallete.darkgradient1
                                    : Pallete.gradient1,
                                border:
                                    Border.all(width: 2, color: Colors.white)),
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.notifications_active),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
                        child: DashboardGrid(
                          items: [
                            GridItem(
                                icon: Icons.inventory,
                                label: "Products",
                                onTap: () {}),
                            GridItem(
                                icon: Icons.list,
                                label: "Orders",
                                onTap: () {}),
                            GridItem(
                                icon: Icons.attach_money,
                                label: "Payment Dues",
                                onTap: () {}),
                            GridItem(
                                icon: Icons.local_shipping,
                                label: "Dispatch Status",
                                onTap: () {}),
                            GridItem(
                                icon: Icons.feedback,
                                label: "Feedback",
                                onTap: () {}),
                            GridItem(
                                icon: Icons.request_page,
                                label: "Sample Request",
                                onTap: () {}),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
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
