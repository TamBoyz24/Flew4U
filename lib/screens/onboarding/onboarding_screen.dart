import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final data = [
    {
      "title": "Explore the world",
      "desc": "Discover beautiful places around the world",
      "image": "assets/images/Onboarding1.png",
    },
    {
      "title": "Find best guides",
      "desc": "Connect with local expert guides",
      "image": "assets/images/Onboarding2.png",
    },
    {
      "title": "Enjoy your trip",
      "desc": "Make your journey unforgettable",
      "image": "assets/images/Onboarding3.png",
    },
  ];

  void finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 244, 181),

      body: Column(
        children: [
          /// 👉 SLIDE
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: data.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (_, i) {
                final item = data[i];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(item["image"]!, height: 300),
                      const SizedBox(height: 30),

                      Text(
                        item["title"]!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        item["desc"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// 👉 DOTS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              data.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(5),
                width: currentIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? Colors.green
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 👉 BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Skip
                TextButton(
                  onPressed: finishOnboarding,
                  child: const Text("Skip"),
                ),

                /// Next / Start
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (currentIndex < data.length - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      finishOnboarding();
                    }
                  },
                  child: Text(
                    currentIndex == data.length - 1 ? "Start" : "Next",
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
