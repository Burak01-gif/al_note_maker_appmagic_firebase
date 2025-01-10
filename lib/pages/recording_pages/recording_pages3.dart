import 'package:flutter/material.dart';

class RecordingPage3 extends StatefulWidget {
  const RecordingPage3({Key? key}) : super(key: key);

  @override
  State<RecordingPage3> createState() => _RecordingPage3State();
}

class _RecordingPage3State extends State<RecordingPage3> {
  bool isPlaying = false;
  double playbackPosition = 0.0;
  Duration totalDuration = const Duration(seconds: 60);
  Duration currentDuration = const Duration(seconds: 0);

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      // Simülasyon için animasyonu başlatıyoruz.
      Future.delayed(const Duration(milliseconds: 100), updatePlaybackPosition);
    }
  }

  void updatePlaybackPosition() {
    if (!isPlaying) return;

    setState(() {
      playbackPosition += 0.01;
      currentDuration = Duration(
          seconds: (totalDuration.inSeconds * playbackPosition).toInt());
      if (playbackPosition >= 1.0) {
        isPlaying = false;
        playbackPosition = 0.0;
      }
    });

    if (isPlaying) {
      Future.delayed(const Duration(milliseconds: 100), updatePlaybackPosition);
    }
  }

  void resetRecording() {
    setState(() {
      isPlaying = false;
      playbackPosition = 0.0;
      currentDuration = const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Record Your Audio",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF1F5), // Light peach
              Color(0xFFECEFFF), // Light lavender
            ],
          ),
        ),
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
              "You can listen to your recorded voice, delete or re-record.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Spacer(flex: 2),
            // Slider ve zaman göstergesi
            Column(
              children: [
                Slider(
                  value: playbackPosition,
                  onChanged: (value) {
                    setState(() {
                      playbackPosition = value;
                      currentDuration = Duration(
                          seconds:
                              (totalDuration.inSeconds * playbackPosition)
                                  .toInt());
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currentDuration.inMinutes}:${(currentDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
            // Oynatma ve silme butonları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: resetRecording,
                  icon: const Icon(
                    Icons.delete,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: togglePlayPause,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3478F6),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "You can listen to your recorded voice, delete or re-record.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Spacer(flex: 2),
            // Generate Summary butonu
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Özet oluşturma aksiyonu
                    print("Generate Summary tapped");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3478F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Generate Summary",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
