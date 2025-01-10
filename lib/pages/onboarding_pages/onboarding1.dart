import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_content.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_title.dart';
import 'package:al_note_maker_appmagic/pages/onboarding_pages/onboarding2.dart';
import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5E4E2), 
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Görsel
            Padding(
              padding: const EdgeInsets.only(left: 22.58),
              child: Center(
                child: Container(
                  width: 382.84, 
                  height: 412.42, 
                  child: Image.asset(
                    'assets/onboarding/onboarding1/onboarding1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Başlık
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomTitle(text: 'Welcome! A New Way to Take Notes'),
            ),
            const SizedBox(height: 20),

            // Açıklama
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomContent(
                text:
                    'Transform your conversations into text and summaries with our AI-powered app. Save time and capture important points effortlessly!',
              ),
            ),
            const SizedBox(height: 40),

            // Buton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Onboarding2()),
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
