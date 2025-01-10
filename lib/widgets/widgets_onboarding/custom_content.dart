import 'package:flutter/material.dart';

class CustomContent extends StatelessWidget {
  final String text;

  const CustomContent({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğine göre font boyutunu dinamik olarak ayarlama
    final screenWidth = MediaQuery.of(context).size.width;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: screenWidth * 0.04, // Dinamik font boyutu
        height: 1.21, // Sabit satır yüksekliği
        fontWeight: FontWeight.w400,
        letterSpacing: -0.02 * (screenWidth * 0.04), // Letter spacing
        color: const Color(0xFF010101),
      ),
    );
  }
}
