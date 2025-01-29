import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:sbtcustomer/core/widgets/gradient_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sbtcustomer/services/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _descriptionController = TextEditingController();
  bool _isProcessing = false;

  Future<void> submitFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String feedback = _descriptionController.text;
    final String customerId = prefs.getString('customer_id')!;

    if (feedback.trim().isEmpty) {
      showSnackbar(
        message: "Description should not be empty",
        backgroundColor: Colors.orange,
      );

      return;
    }

    final Uri url = Uri.parse(Urls().buildUrl(
        'insertFeedbackDetails')); // Replace with your global base URL

    try {
      setState(() {
        _isProcessing = true;
      });
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "pin": Urls.pin, // Replace with your global pin variable
          "customer_id": customerId,
          "feedback": feedback,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData["status"] == true) {
        setState(() {
          _isProcessing = false;
          _descriptionController.clear();
        });
        showSnackbar(
          message: "Feedback submitted successfully",
          backgroundColor: Colors.green,
        );
      } else {
        setState(() {
          _isProcessing = false;
        });
        showSnackbar(
          message: "Failed to submit feedback",
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      setState(() {
        _isProcessing = false;
      });
      showSnackbar(
        message: "An error occurred, please try again",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        title: Text(
          'Feedback',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "We would love to hear from you, feel free to share your Complaints/Issues/Queries/Compliments",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    minLines: 5,
                    maxLines: 5,
                    controller: _descriptionController,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GradientButton(
                  buttonName: 'Submit',
                  onTap: () {
                    submitFeedback();
                  },
                )
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
