import 'dart:convert';
import 'package:flutter/material.dart';

class RecordingSummaryPage extends StatelessWidget {
  final String title;
  final String timestamp;
  final String summary;
  final String transcript;

  const RecordingSummaryPage({
    Key? key,
    required this.title,
    required this.timestamp,
    required this.summary,
    required this.transcript,
  }) : super(key: key);

  // Summary verisini parse etmek için bir yardımcı fonksiyon
  List<Map<String, dynamic>> parseSummary(String summary) {
    try {
      final List<dynamic> summaryList = jsonDecode(summary);
      return summaryList
          .map((item) => {
                'timestamp': item['timestamp'] ?? '',
                'description': item['description'] ?? '',
              })
          .toList();
    } catch (e) {
      print("Error parsing summary: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedSummary = parseSummary(summary);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
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
            // Başlık
            Text(
              title.isNotEmpty ? title : "No Title Available",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Zaman damgası
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  timestamp.isNotEmpty ? timestamp : "No Timestamp Available",
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

            // Özet Bölümü
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
                  parsedSummary.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: parsedSummary.length,
                          itemBuilder: (context, index) {
                            final item = parsedSummary[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['timestamp']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['description']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Text(
                          "No summary available.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Transcript Bölümü
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
                  transcript.isNotEmpty
                      ? Text(
                          transcript,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        )
                      : const Text(
                          "No transcript available.",
                          style: TextStyle(
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
