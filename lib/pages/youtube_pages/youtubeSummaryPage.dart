import 'package:al_note_maker_appmagic/pages/home_pages/home.dart';
import 'package:flutter/material.dart';

// YouTubeSummaryPage Class
class YouTubeSummaryPage extends StatelessWidget {
  final String title; // Video başlığı
  final String timestamp;
  final String summary;
  final String transcript;

  const YouTubeSummaryPage({
    Key? key,
    required this.title,
    required this.timestamp,
    required this.summary,
    required this.transcript,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage(showDialog: false)),
              (Route<dynamic> route) => false, // Stack'i temizleyerek sadece HomePage kalsın
            );
          },
        ),
        title: Text(
          title.isNotEmpty ? title : "Generated Title", 
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.isNotEmpty ? title : "No Title Available",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => print("Add to folder"),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 19,
                        color: Color(0xFF5584EC),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Add to Folder",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5584EC),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary.isNotEmpty ? summary : "No summary available.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Transcript",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transcript.isNotEmpty ? transcript : "No transcript available.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
