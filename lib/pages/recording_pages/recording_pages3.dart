import 'package:al_note_maker_appmagic/animations/recording_page_animations/generatingSummary.dart';
import 'package:al_note_maker_appmagic/pages/recording_pages/recording_pages2.dart';
import 'package:al_note_maker_appmagic/pages/recording_pages/sumaarypages.dart';
import 'package:al_note_maker_appmagic/services/api_services2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordingPage3 extends StatefulWidget {
  final String audioPath; // Yerel ses dosyasının yolu
  final String audioUrl;  // Firebase Storage'dan alınan URL
  final String cardId;

  const RecordingPage3({Key? key, required this.audioPath, required this.audioUrl, required this.cardId}) : super(key: key);

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
  try {
    // Yerel cihazda bulunan ses dosyasını yükle
    String formattedPath = widget.audioPath.replaceAll('.aac', '.m4a');
    await _audioPlayer.setSourceDeviceFile(formattedPath);
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
      await _audioPlayer.setSourceDeviceFile(formattedPath); // Kaynağı yeniden yükle
    });
  } catch (e) {
    print("Error initializing audio: $e");
  }
}


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
    body: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Container(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: const Icon(
                      Icons.mic,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Record your audio",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
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
            
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 185, 12, 00),
                    child: Column(
                      children: [
                        Slider(
                          value: playbackPosition.clamp(0.0, 1.0),
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
                  ),
            
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => RecordAudioPage2(cardId: widget.cardId,)));
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            size: 32,
                            color: Colors.blue,
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
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: const Text(
                      "You can listen to your recorded voice, delete or re-record.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                        textAlign: TextAlign.center,
                        softWrap: true, 
                        overflow: TextOverflow.visible, 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeneratingSummaryPage()),
                );
                final apiService = ApiService2();
                try {
                  final result = await apiService.getRecordingSummary(
                    audioUrl: widget.audioUrl,
                    language: 'en',
                    summarizeRules: 'Summarize the content into key points with timestamps.',
                  );
                  Navigator.pop(context);
                  await FirebaseFirestore.instance.collection('cards')
                      .doc(widget.cardId)
                      .collection('summaries')
                      .doc('default_summary')
                      .set({
                    'title': result['title'] ?? 'Generated Title',
                    'timestamp': result['timestamp'] ?? 'No Timestamp Available',
                    'summary': result['summary'] ?? 'No Summary Available',
                    'transcript': result['transcript'] ?? 'No Transcript Available',
                    'createdAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));
                  await FirebaseFirestore.instance.collection('cards')
                      .doc(widget.cardId)
                      .update({
                    'isGenerated': true,
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryPage(
                        title: result['title'] ?? 'Generated Title',
                        timestamp: result['timestamp'] ?? 'No Timestamp Available',
                        summary: result['summary'] ?? 'No Summary Available',
                        transcript: result['transcript'] ?? 'No Transcript Available',
                        type: 'audio',
                        cardId: widget.cardId,
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to generate summary: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3478F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
  );
}


}
