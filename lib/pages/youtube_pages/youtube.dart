import 'dart:async';
import 'package:al_note_maker_appmagic/pages/youtube_pages/youtubeSummaryPage.dart';
import 'package:al_note_maker_appmagic/services/api_services.dart';
import 'package:flutter/material.dart';

class YouTubePage extends StatefulWidget {
  const YouTubePage({super.key});

  @override
  State<YouTubePage> createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  String selectedLanguage = "Auto Detect";
  String youtubeUrl = "";
  bool isLoading = false;
  String loadingMessage = "Loading YouTube video";
  String summary = "";
  String transcript = "";

  final List<String> languages = [
    "Auto Detect",
    "English",
    "Turkish",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Japanese",
    "Korean",
    "Arabic",
    "Russian",
    "Portuguese",
    "Hindi",
    "Italian",
    "Dutch",
    "Swedish",
    "Polish",
    "Greek",
    "Czech",
    "Danish",
    "Norwegian",
  ];

  void showLanguageMenu(BuildContext context, Offset position) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: languages
          .map(
            (language) => PopupMenuItem<String>(
              value: language,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language),
                  if (language == selectedLanguage)
                    const Icon(Icons.check, color: Colors.blue),
                ],
              ),
            ),
          )
          .toList(),
    );

    if (selected != null) {
      setState(() {
        selectedLanguage = selected;
      });
    }
  }

  Future<void> handleContinue() async {
  if (youtubeUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a YouTube link.")),
    );
    return;
  }

  setState(() {
    isLoading = true;
    loadingMessage = "Processing video...";
  });

  try {
    final ApiService apiService = ApiService();

    // Workflow'u başlat
    print("Triggering workflow...");
    final triggerId = await apiService.triggerWorkflow(
      youtubeUrl,
      selectedLanguage,
      "Summarize the video in key points",
      "Bullet Points",
    );

    if (triggerId == null) {
      throw Exception("Failed to trigger workflow");
    }
    print("Trigger ID: $triggerId");

    // Workflow durumunu kontrol et
    print("Polling execution status...");
    final result = await apiService.pollExecutionStatus(triggerId);
    print("Result from pollExecutionStatus: $result");

    // step_results içindeki verileri kontrol et
    String extractedSummary = "No summary available.";
    String extractedTranscript = "No transcript available.";

    if (result.containsKey('step_results')) {
      final stepResults = result['step_results'] as List;

      for (final step in stepResults) {
        if (step['step_name'] == 'ChatGPT' && step['status'] == 'succeeded') {
          extractedSummary = step['output'] ?? "No summary available.";
        }
        if (step['step_name'] == 'Youtube Transcriptor' &&
            step['status'] == 'succeeded') {
          extractedTranscript = step['output'] ?? "No transcript available.";
        }
      }
    }

    setState(() {
      isLoading = false;
      summary = extractedSummary;
      transcript = extractedTranscript;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubeSummaryPage(
          title: "Generated Title",
          timestamp: "${DateTime.now().hour}:${DateTime.now().minute}",
          summary: summary,
          transcript: transcript,
        ),
      ),
    );
  } catch (e) {
    print("Error in handleContinue: $e");
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "YouTube",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Paste a YouTube link",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => youtubeUrl = value,
                        decoration: InputDecoration(
                          hintText: "Enter YouTube link here",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        print("Paste Button Tapped");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3478F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Paste",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "We'll generate a transcript, notes and a study guide",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Note Language",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showLanguageMenu(context, details.globalPosition);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedLanguage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 210,
                    child: ElevatedButton(
                      onPressed: handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3478F6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      loadingMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
