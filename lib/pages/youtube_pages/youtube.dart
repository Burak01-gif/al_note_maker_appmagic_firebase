import 'package:al_note_maker_appmagic/functions/provider/home_controller.dart';
import 'package:al_note_maker_appmagic/pages/youtube_pages/youtubeSummaryPage.dart';
import 'package:al_note_maker_appmagic/services/api_services.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/continue_button.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/loading_overlay.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/note_language_selector.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/youtube_url_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YouTubePage extends StatefulWidget {
  final String cardId; // Kartın Firestore ID'si

  const YouTubePage({super.key, required this.cardId});

  @override
  State<YouTubePage> createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  String selectedLanguage = "Auto Detect";
  String youtubeUrl = ""; 
  bool isLoading = false; 
  String loadingMessage = "Loading YouTube video"; 

  void showLanguageMenu(BuildContext context, Offset position) async {
  final List<String> popularLanguages = [
    "English",
    "Turkish",
    "Spanish",
    "French",
    "German",
    "Italian",
    "Chinese",
    "Japanese",
    "Russian",
    "Portuguese"
  ];

  final selectedLang = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx + 1, position.dy + 1),
    items: popularLanguages.map((language) {
      return PopupMenuItem<String>(
        value: language,
        child: Text(language),
      );
    }).toList(),
  );

  if (selectedLang != null) {
    setState(() {
      selectedLanguage = selectedLang;  
    });
  }
}


  void handleContinue() async {
  if (youtubeUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid YouTube URL")),
    );
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Colors.black,
            ),
            const SizedBox(height: 16),
            const Text(
              "Loading YouTube video",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please stay on this screen while you wait",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    },
  );

  try {
    final apiService = ApiService();
    final triggerId = await apiService.triggerWorkflow(
      youtubeUrl,
      selectedLanguage,
      "Summarize the video with key points and timestamps.",
      "json",
    );

    if (triggerId == null) {
      throw Exception("Trigger ID could not be retrieved.");
    }

    final result = await apiService.pollExecutionStatus(triggerId);

    final homeController = Provider.of<HomeController>(context, listen: false);
    await homeController.markCardAsGenerated(widget.cardId);

    await homeController.updateCardSummary(
      widget.cardId,
      result['flow_name'] ?? 'Generated Title',
      result['step_results']?[1]['output'] ?? 'No Summary Available',
      result['step_results']?[0]['output'] ?? 'No Transcript Available',
    );

    Navigator.pop(context); 

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubeSummaryPage(
          title: result['flow_name'] ?? 'Generated Title',
          timestamp: DateTime.now().toString(),
          summary: result['step_results']?[1]['output'] ?? 'No Summary Available',
          transcript: result['step_results']?[0]['output'] ?? 'No Transcript Available',
          cardId: widget.cardId,
        ),
      ),
    );
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
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
        title: const Text(
          "YouTube Summary",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
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
                // YouTube URL Girişi
                YouTubeUrlInput(
                  onUrlChanged: (value) {
                    setState(() {
                      youtubeUrl = value; 
                    });
                  },
                  onPaste: () {
                    print("Paste Button Tapped");
                  },
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
                NoteLanguageSelector(
                  selectedLanguage: selectedLanguage,
                  onShowMenu: (position) => showLanguageMenu(context, position),
                ),
                const Spacer(),
                ContinueButton(onPressed: () => handleContinue()),
              ],
            ),
          ),
          if (isLoading) LoadingOverlay(loadingMessage: loadingMessage),
        ],
      ),
    );
  }
}
