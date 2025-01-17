import 'package:al_note_maker_appmagic/pages/recording_pages/recording_summary__pange.dart';
import 'package:al_note_maker_appmagic/services/api_services2.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordingPage3 extends StatefulWidget {
  final String audioPath; // Yerel ses dosyasının yolu
<<<<<<< HEAD
  final String audioUrl;  // Firebase Storage'dan alınan URL

  const RecordingPage3({Key? key, required this.audioPath, required this.audioUrl}) : super(key: key);
=======

  const RecordingPage3({Key? key, required this.audioPath}) : super(key: key);
>>>>>>> 76c7f8081162f010be366ea5417d838273018c82

  @override
  State<RecordingPage3> createState() => _RecordingPage3State();
}

class _RecordingPage3State extends State<RecordingPage3> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double playbackPosition = 0.0; // 0.0 ile 1.0 arasında Slider konumu
  Duration totalDuration = Duration.zero; // Ses kaydının toplam süresi
  Duration currentDuration = Duration.zero; // Çalma esnasındaki süre

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
<<<<<<< HEAD
    try {
      // Yerel cihazda bulunan ses dosyasını yükle
      await _audioPlayer.setSourceDeviceFile(widget.audioPath);
      print("Audio source set successfully.");

      // Toplam süreyi manuel olarak ayarla
      final duration = await _audioPlayer.getDuration();
      if (duration != null) {
        setState(() {
          totalDuration = duration;
        });
      }

      // Toplam süre değişikliğini dinle
      _audioPlayer.onDurationChanged.listen((duration) {
        print("Duration changed: ${duration.inMilliseconds} ms");
        setState(() {
          totalDuration = duration;
        });
      });

      // Çalma pozisyonu değişikliğini dinle
      _audioPlayer.onPositionChanged.listen((position) {
        print("Position changed: ${position.inMilliseconds} ms");
        setState(() {
          currentDuration = position;
          playbackPosition = _sliderSync(position, totalDuration);
        });
      });

      // Çalma tamamlanma olayını dinle
      _audioPlayer.onPlayerComplete.listen((_) async {
        print("Playback completed.");
        setState(() {
          isPlaying = false;
          playbackPosition = 0.0;
          currentDuration = Duration.zero;
        });
        // Kaydı tekrar oynatmaya hazır hale getirmek için kaynak durumunu sıfırla
        await _audioPlayer.stop(); // Çalma durumunu sıfırla
        await _audioPlayer.setSourceDeviceFile(widget.audioPath); // Kaynağı yeniden yükle
      });
    } catch (e) {
      print("Error initializing audio: $e");
    }
  }
=======
  try {
    // Yerel cihazda bulunan ses dosyasını yükle
    await _audioPlayer.setSourceDeviceFile(widget.audioPath);
    print("Audio source set successfully.");

    // Toplam süreyi manuel olarak ayarla
    final duration = await _audioPlayer.getDuration();
    if (duration != null) {
      setState(() {
        totalDuration = duration;
      });
    }

    // Toplam süre değişikliğini dinle
    _audioPlayer.onDurationChanged.listen((duration) {
      print("Duration changed: ${duration.inMilliseconds} ms");
      setState(() {
        totalDuration = duration;
      });
    });

    // Çalma pozisyonu değişikliğini dinle
    _audioPlayer.onPositionChanged.listen((position) {
      print("Position changed: ${position.inMilliseconds} ms");
      setState(() {
        currentDuration = position;
        playbackPosition = _sliderSync(position, totalDuration);
      });
    });

    // Çalma tamamlanma olayını dinle
    _audioPlayer.onPlayerComplete.listen((_) async {
      print("Playback completed.");
      setState(() {
        isPlaying = false;
        playbackPosition = 0.0;
        currentDuration = Duration.zero;
      });
        // Kaydı tekrar oynatmaya hazır hale getirmek için kaynak durumunu sıfırla
      await _audioPlayer.stop(); // Çalma durumunu sıfırla
      await _audioPlayer.setSourceDeviceFile(widget.audioPath); // Kaynağı yeniden yükle
    });
  } catch (e) {
    print("Error initializing audio: $e");
  }
}

>>>>>>> 76c7f8081162f010be366ea5417d838273018c82

  void togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void resetRecording() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      playbackPosition = 0.0;
      currentDuration = Duration.zero;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  double _sliderSync(Duration current, Duration total) {
    if (total.inMilliseconds == 0) {
      return 0.0; // Eğer toplam süre sıfırsa, slider başlangıç pozisyonunda kalır
    }
    return current.inMilliseconds / total.inMilliseconds;
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
              Color(0xFFFFF1F5),
              Color(0xFFECEFFF),
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
                  value: playbackPosition.clamp(0.0, 1.0), // 0 ile 1 arasında tut
                  onChanged: (value) async {
                    final newPosition = Duration(
                      milliseconds: (totalDuration.inMilliseconds * value).toInt(),
                    );
                    await _audioPlayer.seek(newPosition);
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
<<<<<<< HEAD
                  onPressed: () async {
                    final apiService = ApiService2();

                    print("Generate Summary Button Clicked!");
                    print("Audio URL: ${widget.audioUrl}");

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    try {
                      print("Triggering API Workflow...");
                      final triggerId = await apiService.triggerWorkflow(
                        audioUrl: widget.audioUrl,
                        language: 'en',
                        summarizeRules: 'Summarize the content into key points with timestamps.',
                      );

                      if (triggerId == null) {
                        throw Exception("Failed to obtain trigger ID.");
                      }

                      print("Trigger ID Received: $triggerId");

                      final result = await apiService.pollExecutionStatus(triggerId);

                      print("Final API Result: $result");

                      Navigator.pop(context); // Progress barı kapat

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordingSummaryPage(
                            title: result['title'] ?? 'Generated Title',
                            timestamp: result['timestamps']?.toString() ?? 'No Timestamp Available',
                            summary: result['summary'] ?? 'No Summary Available',
                            transcript: result['transcript'] ?? 'No Transcript Available',
                          ),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Progress barı kapat
                      print("Error in Generate Summary Process: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to generate summary: $e')),
                      );
                    }
=======
                  onPressed: () {
                    print("Generate Summary tapped");
>>>>>>> 76c7f8081162f010be366ea5417d838273018c82
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
