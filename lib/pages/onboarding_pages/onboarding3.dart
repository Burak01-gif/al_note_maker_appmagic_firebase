import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_content.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_title.dart';
import 'package:al_note_maker_appmagic/pages/onboarding_pages/onboarding4.dart';
import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Görsel
            Center(
              child: Padding(padding: const EdgeInsets.only(left: 66),
                child: Image.asset(
                  'assets/onboarding/onboarding3/onboarding3.png',
                  width: 384.24,
                  height: 404.08,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Başlık
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomTitle(text: 'Ready to Get Started?'),
            ),
            const SizedBox(height: 20),

            // Açıklama
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), 
              child: CustomContent(
                text:
                    'Record your speech and create your notes. Take notes easily, quickly, and effectively! Start now and keep all your important information at your fingertips.',
              ),
            ),
            const SizedBox(height: 40),

              // Buton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomButton(
                  text: 'Start',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Onboarding4()),
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
