import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const DrawerItem(
      {super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
      onTap: onTap,
    );
  }
}