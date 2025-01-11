import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final int selectedIndex;

  const EmptyStateWidget({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = selectedIndex == 2
        ? 'No Favorites Yet'
        : 'No Audio Files Yet';
    String subMessage = selectedIndex == 2
        ? 'Mark notes as favorite to see them here.'
        : 'Start recording or import audio files to see them here.';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/home/home_mic.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            subMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
