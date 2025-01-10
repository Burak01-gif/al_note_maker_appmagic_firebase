import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_content.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_onboarding/custom_title.dart';
import 'package:al_note_maker_appmagic/pages/home_pages/home.dart';
import 'package:flutter/material.dart';

class Onboarding6 extends StatelessWidget {
  const Onboarding6({super.key});

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Blur tıklanınca hiçbir şey olmaz
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enjoying Transcribe AI?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your app store review helps us grow our community!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              // Yıldız Derecelendirme
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_border,
                    size: 30,
                    color: Colors.yellow[600],
                  );
                }),
              ),
              const SizedBox(height: 20),
              // "Not Now" Düğmesi
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text(
                  "Not Now",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Açık mor arka plan rengi
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Yıldız Görselleri
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Image(
                image: AssetImage('assets/onboarding/onboarding6/img_helpUsGrow@2x.png'),
                width: 379, 
                height: 191, 
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),

            // Başlık
            const CustomTitle(text: 'Share The Love,\nHelp Us Grow'),
            const SizedBox(height: 20),

            // Açıklama
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomContent(
                text: 'It would mean the world if you left a positive rating. Thank you so much!',
              ),
            ),
            const SizedBox(height: 40),

            // Kalp Görseli ve Buton
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Kalp Görseli
                Center(
                  child: Image.asset(
                    'assets/onboarding/onboarding6/img_heart@2x.png',
                    width: 248.0, 
                    height: 227.0, 
                    fit: BoxFit.contain,
                  ),
                ),

                // Buton
                Positioned(
                  bottom: 0.0,
                  left: 24.0,
                  right: 24.0,
                  child: CustomButton(
                    text: "Sure, Let's Go!",
                    onPressed: () {
                      _showRatingDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
