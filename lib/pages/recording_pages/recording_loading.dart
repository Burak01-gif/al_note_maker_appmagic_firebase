import 'package:al_note_maker_appmagic/pages/recording_pages/recording_summary__pange.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSummaryPage();
  }

  Future<void> _navigateToSummaryPage() async {
    // Özetleme işlemi sahte verilerle örneklendirildi (API çağrısını burada yapabilirsiniz)
    await Future.delayed(const Duration(seconds: 3)); // 3 saniye bekleme

    // Sahte veriler (Gerçek verileri API'den alın)
    final title = "Recording Title";
    final timestamp = "03:45";
    final summary = "This is a summary of the recording.";
    final transcript = "This is the full transcript of the recording.";

    // RecordingSummaryPage'e geçiş
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecordingSummaryPage(
          title: title,
          timestamp: timestamp,
          summary: summary,
          transcript: transcript,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Center(
              child: Text(
                "Generating Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Color(0xFF3478F6),
            ),
          ],
        ),
      ),
    );
  }
}
