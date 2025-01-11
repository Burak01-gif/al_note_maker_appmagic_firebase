import 'package:al_note_maker_appmagic/pages/recording_pages/recording_pages3.dart';
import 'package:al_note_maker_appmagic/widgets/recording_widgets/recording_appbar_widget.dart';
import 'package:al_note_maker_appmagic/widgets/recording_widgets/recording_backgroundcolor_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RecordAudioPage2 extends StatefulWidget {
  const RecordAudioPage2({Key? key}) : super(key: key);

  @override
  State<RecordAudioPage2> createState() => _RecordAudioPage2State();
}

class _RecordAudioPage2State extends State<RecordAudioPage2> {
  bool isRecording = false; // Kaydın devam edip etmediği
  bool isProcessing = false; // İşleme durumu
  int secondsElapsed = 0; // Geçen süre
  Timer? timer;

  void startRecording() {
    setState(() {
      isRecording = true;
      secondsElapsed = 0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void stopRecording() {
    timer?.cancel();
    setState(() {
      isRecording = false;
      isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isProcessing = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecordingPage3(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const RecordingAppbarWidget(),
      body: GradientBackground(
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(
              Icons.mic,
              size: 64,
              color: Colors.black,
            ),
            const SizedBox(height: 16),
            const Text(
              "Record your audio",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Record your audio with high quality.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Spacer(flex: 2),
            // Çember ve işlem durumu
            SizedBox(
              height: 200,
              width: 200,
              child: isRecording
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: 1,
                            color: Colors.white,
                            strokeWidth: 12,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: (secondsElapsed % 60) / 60,
                            color: const Color(0xFF3478F6),
                            strokeWidth: 12,
                          ),
                        ),
                        Text(
                          "${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  : isProcessing
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF3478F6),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Record processing",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Please wait...",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(), // Başlangıçta boş kalır
            ),
            const Spacer(flex: 3),
            GestureDetector(
              onTap: isRecording ? stopRecording : startRecording,
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
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
