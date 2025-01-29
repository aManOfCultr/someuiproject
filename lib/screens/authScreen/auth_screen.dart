import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/core/widgets/gradient_button.dart';
import 'package:sbtcustomer/core/widgets/custom_field.dart';
import 'package:sbtcustomer/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:sbtcustomer/screens/home/widgets/dashboard_grid.dart';
import 'package:sbtcustomer/services/save_user_data.dart';
import 'package:sbtcustomer/services/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_divider/wave_divider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _otpSent = false;
  bool _pinLogin = false;
  bool _isProcessing = false;
  DateTime? lastPressed;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();

    if (lastPressed == null ||
        now.difference(lastPressed!) > Duration(seconds: 2)) {
      lastPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isDarkMode ? Pallete.gradient3 : Pallete.gradient3,
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );

      return Future.value(false); // Don't exit the app
    }

    return Future.value(true); // Exit the app
  }

  Future<void> _verifyOTP() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String enteredOtp = _otpController.text;
      String actualOtp = prefs.getInt('otp').toString();
      if (enteredOtp == actualOtp) {
        prefs.setBool('authenticated', true);
        _navigateTo(page: HomeScreen());
      } else {
        prefs.setBool('authenticated', true);
        showSnackbar(
          message: "Entered OTP is incorrect",
          backgroundColor: Colors.red,
        );
      }
    }
  }

  Future<void> _verifyMobile() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      String phoneNumber = _phoneController.text;
      final Map<String, String> body = {
        'pin': Urls.pin,
        'number': phoneNumber,
      };
      try {
        final response = await http.post(
          Uri.parse(Urls().buildUrl('mobile_verify')),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body,
        );
        print(response.body);
        Map<String, dynamic> userData = json.decode(response.body);
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          if (responseData['status'] == "true") {
            showSnackbar(
                message:
                    "OTP sent to $phoneNumber and it is ${responseData['otp']}",
                backgroundColor: Colors.green);
            setState(() {
              _otpSent = true;
              _isProcessing = false;
            });
            saveUserData(userData);
          } else {
            showSnackbar(message: "User Blocked", backgroundColor: Colors.red);
            setState(() {
              _isProcessing = false;
            });
          }
        } else {
          // Handle login failure
          showSnackbar(
            message: 'Invalid credentials!',
            backgroundColor: Colors.red,
          );
          setState(() {
            _isProcessing = false;
          });
        }
      } catch (e) {
        showSnackbar(
          message: 'An error occurred: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the theme provider using ref
    final themeMode = ref.watch(themeNotifierProvider);

    // Determine if it's dark mode
    final isDarkMode = themeMode == ThemeMode.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                                ? Hero(
                                    tag: 'Dark Logo',
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/img/new_sbt_dark_logo.png'),
                                    ),
                                  )
                                : Hero(
                                    tag: 'Light Logo',
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/img/new_sbt_logo.png'),
                                    ),
                                  ),
                            const SizedBox(
                              height: 30,
                            ),
                            if (!_otpSent)
                              CustomField(
                                hintText: 'Phone',
                                keyboardType: TextInputType.numberWithOptions(),
                                controller: _phoneController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your phone number';
                                  }
                                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                    return 'Enter a valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                            if (_otpSent & !_pinLogin)
                              CustomField(
                                icon: Icons.message_outlined,
                                keyboardType: TextInputType.numberWithOptions(),
                                hintText: "Enter OTP",
                                controller: _otpController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the OTP';
                                  }
                                  final otpRegExp = RegExp(r'^\d{4}$');
                                  if (!otpRegExp.hasMatch(value)) {
                                    return 'OTP must be a 4-digit number';
                                  }

                                  return null; // Valid OTP
                                },
                              ),

                            // Pin page
                            if (_otpSent & _pinLogin)
                              CustomField(
                                icon: Icons.password,
                                hintText: "Enter Pin",
                                obscureText: true,
                                controller: _otpController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Pin';
                                  }
                                  final otpRegExp = RegExp(r'^\d{4}$');
                                  if (!otpRegExp.hasMatch(value)) {
                                    return 'Pin must be a 4-digit number';
                                  }

                                  return null; // Valid OTP
                                },
                              ),
                            const SizedBox(height: 20),
                            GradientButton(
                              isProcessing: _isProcessing,
                              onTap: () {
                                if (_otpSent & !_pinLogin) {
                                  _verifyOTP();
                                }
                                if (_otpSent & _pinLogin) {
                                  _verifyOTP();
                                }
                                if (!_otpSent) {
                                  _verifyMobile();
                                }
                              },
                              buttonName: _otpSent
                                  ? _pinLogin
                                      ? 'Verify Pin'
                                      : 'Verify OTP'
                                  : 'Request Otp',
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (_otpSent)
                              GestureDetector(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear;
                                  setState(() {
                                    _otpSent = false;
                                  });
                                  _navigateTo(
                                    page: AuthScreen(),
                                  );
                                },
                                child: Text("Change Number",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Pallete.darkgradient2
                                          : Pallete.gradient1,
                                    )),
                              ),
                            SizedBox(
                              height: 15,
                            ),
                            if (_otpSent)
                              Column(
                                children: [
                                  // Squiggly Line + 'or' Text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 8, 8, 25),
                                          child: WaveDivider(
                                            thickness: 2,
                                            color: isDarkMode
                                                ? Pallete.darkgradient2
                                                : Pallete.gradient1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 25),
                                        child: Text(
                                          'or',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: isDarkMode
                                                ? Pallete.darkgradient2
                                                : Pallete.gradient1,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 25, 25),
                                          child: WaveDivider(
                                            thickness: 2,
                                            color: isDarkMode
                                                ? Pallete.darkgradient2
                                                : Pallete.gradient1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 25),

                                  // Login Button Section
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Login using ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode
                                              ? Pallete.darkgradient2
                                              : Pallete.gradient1,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            isDarkMode
                                                ? Pallete.darkgradient1
                                                : Pallete.gradient1,
                                          ),
                                          padding: WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 12),
                                          ),
                                          shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _pinLogin = !_pinLogin;
                                          });
                                        },
                                        child: Text(
                                          _pinLogin ? "OTP" : "Pin",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
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
                  themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
                );
          },
          child: const Icon(Icons.brightness_6),
        ),
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
