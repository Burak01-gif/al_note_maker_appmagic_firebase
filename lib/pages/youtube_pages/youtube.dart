import 'package:al_note_maker_appmagic/widgets/youtube_widgets/continue_button.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/loading_overlay.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/note_language_selector.dart';
import 'package:al_note_maker_appmagic/widgets/youtube_widgets/youtube_url_input.dart';
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

  void showLanguageMenu(BuildContext context, Offset position) async {
    // Dil seçimi
  }

  Future<void> handleContinue() async {
    // Devam işlemi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // AppBar yapısı
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YouTubeUrlInput(
                  onUrlChanged: (value) => youtubeUrl = value,
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
                ContinueButton(onPressed: handleContinue),
              ],
            ),
          ),
          if (isLoading) LoadingOverlay(loadingMessage: loadingMessage),
        ],
      ),
    );
  }
}
