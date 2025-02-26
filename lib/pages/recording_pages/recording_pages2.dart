import 'package:al_note_maker_appmagic/animations/recording_page_animations/record_progress.dart';
import 'package:al_note_maker_appmagic/widgets/recording_widgets/recording_appbar_widget.dart';
import 'package:al_note_maker_appmagic/widgets/recording_widgets/recording_backgroundcolor_widget.dart';
import 'package:al_note_maker_appmagic/widgets/recording_widgets/recording_button_widget.dart';
import 'package:al_note_maker_appmagic/widgets/recording_widgets/recording_heador_widget.dart';
import 'package:al_note_maker_appmagic/pages/recording_pages/recording_pages3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

class RecordAudioPage2 extends StatefulWidget {
  final String cardId;

  const RecordAudioPage2({Key? key, required this.cardId}) : super(key: key);

  @override
  State<RecordAudioPage2> createState() => _RecordAudioPage2State();
}

class _RecordAudioPage2State extends State<RecordAudioPage2> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false; 
  bool isProcessing = false;
  int secondsElapsed = 0;
  String? recordedFilePath;
  String? recordedFileUrl; // Firebase Storage URL
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      await _recorder.openRecorder();
      print("Recorder initialized successfully.");
    } catch (e) {
      print("Error initializing recorder: $e");
    }
  }

  Future<bool> _requestPermissions() async {
    print("Requesting permissions...");
    final statuses = await [
      Permission.microphone,
      Permission.storage,
      if (Platform.isAndroid) Permission.manageExternalStorage,
    ].request();

    final microphoneGranted = statuses[Permission.microphone]?.isGranted ?? false;
    final storageGranted = statuses[Permission.storage]?.isGranted ?? false;
    final manageStorageGranted = statuses[Permission.manageExternalStorage]?.isGranted ?? false;

    if (!microphoneGranted || (!storageGranted && !manageStorageGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mikrofon ve depolama izinleri gerekli.")),
      );
      return false;
    }
    return microphoneGranted && (storageGranted || manageStorageGranted);
  }

  Future<void> startRecording() async {
  if (!await _requestPermissions()) {
    print("Permissions are not sufficient.");
    return;
  }

  try {
    final directory = await getApplicationDocumentsDirectory();
    recordedFilePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.startRecorder(
      toFile: recordedFilePath,
      codec: Codec.aacMP4,  // m4a formatı için uygun codec
    );

    setState(() {
      isRecording = true;
      secondsElapsed = 0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  } catch (e) {
    print("Error starting recorder: $e");
  }
}

Future<void> stopRecording() async {
  try {
    await _recorder.stopRecorder();
    timer?.cancel();
    setState(() {
      isRecording = false;
      isProcessing = true;
    });

    if (recordedFilePath != null) {
      recordedFileUrl = await _uploadToFirebase(File(recordedFilePath!));
      print("Uploaded file URL: $recordedFileUrl");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecordingPage3(
            audioPath: recordedFilePath!,
            audioUrl: recordedFileUrl!,
            cardId: widget.cardId,
          ),
        ),
      );
    } else {
      setState(() {
        isProcessing = false;
      });
    }
  } catch (e) {
    print("Error stopping recorder: $e");
    setState(() {
      isProcessing = false;
    });
  }
}

Future<String?> _uploadToFirebase(File file) async {
  try {
    final fileName = file.path.split('/').last;
    final storageRef = FirebaseStorage.instance.ref().child('audio_files/$fileName');

    final uploadTask = storageRef.putFile(
      file,
      SettableMetadata(contentType: 'audio/mp4'),  
    );

    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Error uploading to Firebase: $e");
    return null;
  }
}


  @override
  void dispose() {
    _recorder.closeRecorder();
    timer?.cancel();
    super.dispose();
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
          const RecordingHeaderWidget(),
          const Spacer(flex: 2),
          if (isProcessing) 
            SizedBox(
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
children: [
  const DotsLoadingIndicator(),
  const SizedBox(height: 16),
  const Text(
    "Record processing",
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  const SizedBox(height: 8),
  const Text(
    "Please wait...",
    style: TextStyle(
      fontSize: 16,
      color: Colors.grey,
    ),
  ),
]

              ),
            )
          else
            SizedBox(
              height: 200,
              width: 220,
              child: isRecording
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        // Arka plan çemberi (boş çember efekti)
                        SizedBox(
                          height: 189,
                          width: 189,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            backgroundColor: Colors.white,
                            color: Colors.white.withOpacity(0.3),
                            strokeWidth: 12,
                          ),
                        ),
                        // Dış ilerleme çemberi (kayıt süresine göre ilerliyor)
                        SizedBox(
                          height: 189,
                          width: 189,
                          child: CircularProgressIndicator(
                            value: (secondsElapsed % 60) / 60.0, 
                            color: const Color(0xFF3478F6),
                            strokeWidth: 10,
                          ),
                        ),
                        // Sayaç metni
                        Positioned(
                          child: Text(
                            "${(secondsElapsed ~/ 60).toString().padLeft(2, '0')}:${(secondsElapsed % 60).toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),  // Kayıt başlamadan önce hiçbir şey gösterme
            ),
          const Spacer(flex: 3),
          RecordingActionWidget(
            isRecording: isRecording,
            isProcessing: isProcessing,
            onStartRecording: startRecording,
            onStopRecording: stopRecording,
          ),
          const Spacer(flex: 2),
        ],
      ),
    ),
  );
}
}