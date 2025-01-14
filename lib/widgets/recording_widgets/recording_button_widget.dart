import 'package:flutter/material.dart';

class RecordingActionWidget extends StatelessWidget {
  final bool isRecording; // Kayıt durumu
  final bool isProcessing; // İşleme durumu
  final VoidCallback onStartRecording; // Kayıt başlatma işlevi
  final VoidCallback onStopRecording; // Kayıt durdurma işlevi

  const RecordingActionWidget({
    Key? key,
    required this.isRecording,
    required this.isProcessing,
    required this.onStartRecording,
    required this.onStopRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isProcessing
          ? null // İşleme sırasında buton devre dışı
          : (isRecording ? onStopRecording : onStartRecording),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isProcessing
                  ? Colors.grey // İşleme sırasında gri olur
                  : const Color(0xFF3478F6), // Normal durumda mavi
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              isProcessing
                  ? Icons.hourglass_top // İşleme sırasında kum saati
                  : (isRecording ? Icons.stop : Icons.mic),
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isProcessing
                ? "Processing..." // İşleme sırasında mesaj
                : (isRecording
                    ? "Tap to finish recording"
                    : "Tap to start recording"),
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
