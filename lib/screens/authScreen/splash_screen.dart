import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/authScreen/auth_screen.dart';
import 'package:sbtcustomer/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    getLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Durations.extralong4);
    if (prefs.getBool('authenticated') == null ||
        !prefs.getBool('authenticated')!) {
      _navigateTo(page: AuthScreen());
    } else {
      _navigateTo(page: HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the theme provider using ref
    final themeMode = ref.watch(themeNotifierProvider);

    // Determine if it's dark mode
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
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
          // SBT logo
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isDarkMode
                  ? Hero(
                      tag: 'Dark Logo',
                      child: const Image(
                        image: AssetImage('assets/img/new_sbt_dark_logo.png'),
                      ),
                    )
                  : Hero(
                      tag: 'Light Logo',
                      child: const Image(
                        image: AssetImage('assets/img/new_sbt_logo.png'),
                      ),
                    ),
            ],
          )
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

  void _navigateTo({required Widget page}) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => page,
    ));
  }

  void showSnackbar({
    // required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    // Clear any existing SnackBars
    messenger.hideCurrentSnackBar();

    // Show new SnackBar
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Makes it float above bottom bars
      ),
    );
  }
}
