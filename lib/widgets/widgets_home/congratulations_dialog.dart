import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:al_note_maker_appmagic/pages/home_pages/home.dart';

class CongratulationsDialog extends StatelessWidget {
  final VoidCallback onClose;

  const CongratulationsDialog({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: GestureDetector(
        onTap: onClose, // Dışına tıklanınca kapanmasını sağla
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              width: 323,
              height: 177,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7), // Arka plan rengi
                borderRadius: BorderRadius.circular(15), // Köşe yuvarlaklığı
                border: Border.all(color: const Color(0xFFB3BBBA), width: 0.5), // Çerçeve rengi
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Congratulations!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 22 / 18,
                      letterSpacing: 0.3,
                      color: Color(0xFF000000),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You have 30 minutes of usage",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 18 / 14,
                      letterSpacing: 0.2,
                      color: Color(0xFF000000),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(showDialog: false),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3478F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
