import 'package:flutter/material.dart';

class YouTubeUrlInput extends StatelessWidget {
  final Function(String) onUrlChanged;
  final VoidCallback onPaste;

  const YouTubeUrlInput({
    Key? key,
    required this.onUrlChanged,
    required this.onPaste,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Paste a YouTube link",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onUrlChanged,
                decoration: InputDecoration(
                  hintText: "Enter YouTube link here",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onPaste,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3478F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Paste",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "We'll generate a transcript, notes and a study guide",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
