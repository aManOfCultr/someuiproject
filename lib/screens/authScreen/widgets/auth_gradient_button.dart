import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';

class AuthGradientButton extends ConsumerWidget {
  const AuthGradientButton({
    super.key,
    required this.buttonName,
    required this.onTap,
  });
  final String buttonName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: themeMode == ThemeMode.dark
              ? <Color>[
                  Pallete.darkgradient2,
                  Pallete.darkgradient2,
                ]
              : <Color>[
                  Pallete.gradient1,
                  Pallete.gradient1,
                ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        child: Text(
          buttonName,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: !(themeMode == ThemeMode.dark)
                  ? Pallete.lightbackgroundColor
                  : Pallete.backgroundColor),
        ),
      ),
    );
  }
}
