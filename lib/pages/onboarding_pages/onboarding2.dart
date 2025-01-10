import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_content.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_title.dart';
import 'package:al_note_maker_appmagic/pages/onboarding_pages/onboarding3.dart';
import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E1), // Açık turuncu arka plan rengi
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Görsel
            Padding(
              padding: const EdgeInsets.only(left: 22.58), // Onboarding1 ile tutarlı padding
              child: Center(
                child: Container(
                  width: 382.84, // Onboarding1 ile aynı genişlik
                  height: 412.42, // Onboarding1 ile aynı yükseklik
                  child: Image.asset(
                    'assets/onboarding/onboarding2/onboarding2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Başlık
            const Padding(
              padding: EdgeInsets.all(16.0), // Onboarding1 ile uyumlu padding
              child: CustomTitle(text: 'Capture All Your Conversations and Videos'),
            ),
            const SizedBox(height: 20),

            // Açıklama
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomContent(
                text:
                    'Our app automatically records and summarizes your conversations and YouTube videos. Never miss a detail!',
              ),
            ),
            const SizedBox(height: 40),

            // Buton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Onboarding1 ile aynı padding
              child: CustomButton(
                text: 'Start',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Onboarding3()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
