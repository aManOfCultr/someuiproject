import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sbtcustomer/core/theme/app_pallete.dart';
import 'package:sbtcustomer/core/theme/theme_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sbtcustomer/services/urls.dart';

class FAQScreen extends ConsumerStatefulWidget {
  const FAQScreen({super.key});

  @override
  ConsumerState<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends ConsumerState<FAQScreen> {
  List<dynamic> faqsData = [];
  bool isLoading = true;
  bool isHindi = false;

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      final response = await http.post(
        Uri.parse(Urls().buildUrl('getFaq')),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'pin': Urls.pin},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            faqsData = data['data'];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleLanguage() {
    setState(() {
      isHindi = !isHindi;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    bool isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Pallete.darkgradient1 : Pallete.gradient1,
        title: const Text(
          'FAQ/Help',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: toggleLanguage,
              icon: Image.asset(
                'assets/img/language.png',
                width: 30,
                height: 30,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: isDarkMode
                      ? Image.asset(
                          'assets/img/dark-footer.png',
                          fit: BoxFit.cover,
                          height: 100,
                        )
                      : Image.asset(
                          'assets/img/footer.png',
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: faqsData.length,
                    itemBuilder: (context, index) {
                      final faq = faqsData[index];
                      return Card(
                        elevation: 2,
                        color: isDarkMode
                            ? Pallete.darkgradient1
                            : Pallete.gradient2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          iconColor: Colors.black,
                          title: Text(
                            "Q.${faq['faq_id']} " + (isHindi ? faq['faq_que_hi'] : faq['faq_que_en']),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                isHindi ? faq['faq_ans_hi'] : faq['faq_ans_en'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(themeNotifierProvider.notifier).setThemeMode(
                themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
              );
        },
        child: const Icon(Icons.brightness_6),
      ),
    );
  }
}
