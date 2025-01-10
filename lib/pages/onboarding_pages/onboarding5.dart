import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_button.dart';
import 'package:al_note_maker_appmagic/pages/onboarding_pages/onboarding6.dart';
import 'package:flutter/material.dart';

class Onboarding5 extends StatelessWidget {
  const Onboarding5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Üst Görsel
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  'assets/onboarding/onboarding5/img_30minFree@2x.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //const SizedBox(height: 10),

            // Açıklama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "You receive\n", // İlk satır
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 18, // Daha ince yazı
                        height: 1.4, // Satır yüksekliği
                        letterSpacing: -0.02,
                        color: Color(0xFF010101),
                      ),
                    ),
                    TextSpan(
                      text: "30 minutes FREE\n", // Vurgulanmış ikinci satır
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700, // Daha kalın font
                        fontSize: 22, // Daha büyük font
                        height: 1.4, // Satır yüksekliği
                        letterSpacing: -0.02,
                        color: Color(0xFF010101),
                      ),
                    ),
                    TextSpan(
                      text: "each month!", // Son satır
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 18, // Daha ince yazı
                        height: 1.4, // Satır yüksekliği
                        letterSpacing: -0.02,
                        color: Color(0xFF010101),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Hediye ve Buton
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Gradient Green Grid
                  Positioned(
                    bottom: 0, // Gradient en altta yer alır
                    child: Image.asset(
                      'assets/onboarding/onboarding5/gradient_brown@2x.png',
                      width: MediaQuery.of(context).size.width,
                      height: 274.0,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Hediye Görseli
                  Positioned(
                    bottom: 40,
                    child: Image.asset(
                      'assets/onboarding/onboarding5/gift.png',
                      width: 582,
                      height: 398,
                      fit: BoxFit.contain,
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
                              builder: (context) => const Onboarding6(),
                            ),
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
