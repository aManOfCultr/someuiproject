import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/core/widgets/custom_field.dart';
import 'package:sbtcustomer/services/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Platform-specific toggle widget
Widget platformToggle(
    {required bool value, required Function(bool) onChanged}) {
  return Platform.isIOS
      ? CupertinoSwitch(value: value, onChanged: onChanged)
      : Switch(value: value, onChanged: onChanged);
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool isEditingPin = false;
  String pin = "";
  final TextEditingController _pinController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserPin();
  }

  Future<void> getUserPin() async {
    try {
      final response = await http.post(
        Uri.parse(Urls().buildUrl('getCustomerPin')),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'pin': Urls.pin,
          'customer_id': "123"
        }, // Replace with actual customer_id
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] && data['data'][0]['login_pin'] != null) {
          setState(() {
            pin = data['data'][0]['login_pin'];
            _pinController.text = pin;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      showSnackbar(
          message: "An error occured while fetching pin: $e",
          backgroundColor: Pallete.errorColor);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> changePin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getString('customer_id');
    if (_pinController.text.length != 4) {
      showSnackbar(
        message: "Pin must be 4 digits long",
        backgroundColor: Pallete.errorColor,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(Urls().buildUrl('updateCustomerPin')),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'pin': Urls.pin,
          'customer_id': customerId, // Replace with actual customer_id
          'login_pin': _pinController.text
        },
      );
      print(response.body);
      final responseJson = json.decode(response.body);
      if (responseJson['status'] == true) {
        setState(() {
          _pinController.clear();
          isEditingPin = false;
        });
        showSnackbar(
          message: responseJson['message'],
          backgroundColor: Pallete.greenColor,
        );
      } else {
        showSnackbar(
          message: responseJson['message'],
          backgroundColor: Pallete.errorColor,
        );
      }
    } catch (e) {
      showSnackbar(
        message: 'An error occured: $e',
        backgroundColor: Pallete.errorColor,
      );
    }
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Operation Failed"),
        content: const Text("Something went wrong, please try again later."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        title: const Text(
          'Settings',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: isDarkMode
                ? Image.asset('assets/img/dark-footer.png',
                    fit: BoxFit.cover, height: 100)
                : Image.asset('assets/img/footer.png',
                    fit: BoxFit.cover, height: 100),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomField(
                        icon: Icons.password,
                        hintText: 'Pin Number',
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        // enabled: isEditingPin,
                      ),
                    ),
                    IconButton(
                      icon: Icon(isEditingPin ? Icons.check : Icons.edit,
                          color: isDarkMode ? Colors.white : Colors.black),
                      onPressed: () {
                        if (isEditingPin) {
                          changePin();
                        } else {
                          setState(() {
                            isEditingPin = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? Pallete.darkgradient1 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  child: ListTile(
                    title: Text('Dark Mode',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                    trailing: platformToggle(
                      value: isDarkMode,
                      onChanged: (bool value) {
                        ref.read(themeNotifierProvider.notifier).setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? Pallete.darkgradient1 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: ListTile(
                    title: Text('Enable Notifications',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                    trailing: platformToggle(
                      value: false,
                      onChanged: (bool value) {},
                    ),
                  ),
                ),
                ListTile(
                  title: Text('App Version',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black)),
                  trailing: Text('2.3',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
