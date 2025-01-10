import 'package:flutter/material.dart';

Widget showCreateNoteButton(BuildContext context, VoidCallback onPressed) {
  return Container(
    padding: const EdgeInsets.fromLTRB(50, 16, 50, 16),
    child: SizedBox(
      height: 60,
      width: 210,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3478F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Create Note',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
