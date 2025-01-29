import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';

class GradientButton extends ConsumerWidget {
  const GradientButton({
    super.key,
    required this.buttonName,
    required this.onTap,
  });
  final String buttonName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isdarkmode = themeMode == ThemeMode.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: themeMode == ThemeMode.dark
              ? <Color>[
                  Pallete.darkgradient1,
                  Pallete.darkgradient1,
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
          fixedSize: const Size(410, 55),
        ),
        child: Text(
          buttonName,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isdarkmode
                  ? Pallete.lightbackgroundColor
                  : Pallete.backgroundColor),
        ),
      ),
    );
  }
}
