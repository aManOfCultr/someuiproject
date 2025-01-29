import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';

class CustomField extends ConsumerWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.obscureText,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.icon, // Custom icon to display inside the field
  });

  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool? obscureText; // Allows the user to pass custom obscureText or default
  final String? Function(String?)? validator; // Optional custom validator
  final ValueChanged<String>? onChanged; // Callback for input change
  final Widget? prefixIcon; // Optional prefix icon (e.g., larger widgets)
  final Widget? suffixIcon; // Optional suffix icon
  final IconData? icon; // Custom icon to show as a prefix inside the field

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;

    return TextFormField(
      cursorColor: isDarkMode ? Pallete.darkgradient2 : Pallete.gradient1,
      controller: controller,
      keyboardType: keyboardType, // Set keyboard type if provided
      obscureText: obscureText ?? isPassword, // Default to isPassword if obscureText is not provided
      validator: validator, // Use provided validator or none
      onChanged: onChanged, // Trigger the onChanged callback when text changes
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black, 
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, 
        ),
        prefixIcon: icon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon, // Show the custom icon inside the field
                  color: isDarkMode ? Pallete.darkgradient2 : Pallete.gradient1,
                  size: 40,
                ),
              )
            : prefixIcon, // Use prefixIcon if provided and no custom icon
        suffixIcon: suffixIcon, // Optional suffix icon
      ),
    );
  }
}
