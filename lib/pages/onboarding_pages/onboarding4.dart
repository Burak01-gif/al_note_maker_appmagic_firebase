import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_title.dart';
import 'package:al_note_maker_appmagic/pages/onboarding_pages/onboarding5.dart';
import 'package:flutter/material.dart';

class Onboarding4 extends StatelessWidget {
  const Onboarding4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5E4E2),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mikrofon Görseli
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 81.0),
                child: Image.asset(
                  'assets/onboarding/onboarding4/onboarding4_mic.png',
                  width: 246.0,
                  height: 246.0,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Başlık
            const CustomTitle(text: 'Welcome to Transcribe AI!'),
            const SizedBox(height: 16),

            // Updated Açıklama Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "For a limited time, we're offering a\n",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        height: 28 / 20,
                        letterSpacing: -0.02 * 20,
                        color: Color(0xFF010101),
                      ),
                    ),
                    TextSpan(
                      text: "free welcome gift\n",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 28 / 20,
                        letterSpacing: -0.02 * 20,
                        color: Color(0xFF010101),
                      ),
                    ),
                    TextSpan(
                      text: "as part of our 2024 launch!",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        height: 28 / 20,
                        letterSpacing: -0.02 * 20,
                        color: Color(0xFF010101),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Hediye ve Buton
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Gradient Green Grid
                  Positioned(
                    bottom: 0, // Gradient en altta yer alır
                    child: Image.asset(
                      'assets/onboarding/onboarding4/onboarding4_gradient_green.png',
                      width: MediaQuery.of(context).size.width,
                      height: 274.0,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Hediye Görseli
                  Positioned(
                    bottom: 40,
                    child: Image.asset(
                      'assets/onboarding/onboarding4/onboarding4_gift.png',
                      width: 428.0,
                      height: 342.0,
                    ),
                  ),

                  // Buton
                  Positioned(
                    bottom: 80,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CustomButton(
                        text: 'Claim Now',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Onboarding5()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
