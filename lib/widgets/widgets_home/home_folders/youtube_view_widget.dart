import 'package:flutter/material.dart';

/// Widget to display the YouTube tab's empty state.
class YouTubeViewWidget extends StatelessWidget {
  const YouTubeViewWidget(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_circle_outline, size: 100, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            "No YouTube Imports Yet",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Use Lorem to Summarize YouTube Videos",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
