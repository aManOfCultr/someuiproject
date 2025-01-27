import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/screens/auth/widgets/auth_gradient_button.dart';
import 'package:sbtcustomer/screens/auth/widgets/custom_field.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sbtcustomer/screens/home/home_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _otpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the theme provider using ref
    final themeMode = ref.watch(themeNotifierProvider);

    // Determine if it's dark mode
    final isDarkMode = themeMode == ThemeMode.system
        ? WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        : themeMode == ThemeMode.dark;

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
          // Main Content

          Padding(
            padding: EdgeInsets.fromLTRB(
                15.0,
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? 150
                    : 300.0 - MediaQuery.of(context).viewInsets.bottom,
                15.0,
                0.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display logo based on the theme
                          isDarkMode
                              ? const Image(
                                  image: AssetImage(
                                      'assets/img/new_sbt_dark_logo.png'),
                                )
                              : const Image(
                                  image:
                                      AssetImage('assets/img/new_sbt_logo.png'),
                                ),
                          const SizedBox(
                            height: 30,
                          ),
                          if (!_otpSent)
                            CustomField(
                              hintText: 'Phone',
                              controller: phoneController,
                            ),
                          if (_otpSent)
                            OtpTextField(
                              numberOfFields: 4,
                              borderColor: Pallete.gradient2,
                              // cursorColor: Pallete.transparentColor,
                              focusedBorderColor: Pallete.gradient1,
                              enabledBorderColor: Pallete.gradient2,
                              //set to true to show as box or false to show as dash
                              showFieldAsBox: true,
                              //runs when a code is typed in
                              onCodeChanged: (String code) {
                                //handle validation or checks here
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Verification Code"),
                                        content: Text(
                                            'Code entered is $verificationCode'),
                                      );
                                    });
                              }, // end onSubmit
                            ),
                          const SizedBox(height: 20),
                          AuthGradientButton(
                            onTap: () {
                              if (_otpSent) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              }
                              setState(() {
                                _otpSent = true;
                              });
                            },
                            buttonName: _otpSent ? 'Verify Otp' : 'Request Otp',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space for the footer
                ],
              ),
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
