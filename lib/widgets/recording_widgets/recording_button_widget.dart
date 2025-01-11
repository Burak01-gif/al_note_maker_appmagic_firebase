import 'package:flutter/material.dart';

class RecordingActionWidget extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const RecordingActionWidget({
    Key? key,
    required this.isRecording,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRecording ? onStopRecording : onStartRecording,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF3478F6),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isRecording
                ? "Tap to finish recording"
                : "Tap to start recording",
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
