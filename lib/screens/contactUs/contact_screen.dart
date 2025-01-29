import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.gradient1,
        title: Text(
          'Contact Us',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Headquarters:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'SBT Textiles Pvt. Ltd., 589 Urla Industrial Area, Raipur [C.G.] 493221',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Email: raipur@sbttextiles.com',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchDialer('+919300054310'),
                  child: Text(
                    'Mobile: (+91) 9300054310',
                    style: const TextStyle(
                        color: Pallete.gradient1,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Respective Sales Staff',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Name: Aditya Mishra',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Email: am@sbt',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchDialer('+919111010422'),
                  child: Text(
                    'Mobile Number: (+91) 9111010422',
                    style: const TextStyle(
                        color: Pallete.gradient1,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dispatch Details',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchDialer('+919300054810'),
                  child: Text(
                    'Contacts: (+91) 9300054810',
                    style: const TextStyle(
                        color: Pallete.gradient1,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _launchDialer('+919111009975'),
                  child: Text(
                    'Contacts: (+91) 9111009975',
                    style: const TextStyle(
                        color: Pallete.gradient1,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
