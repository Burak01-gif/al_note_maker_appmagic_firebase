import 'package:al_note_maker_appmagic/functions/home/home_controller.dart';
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
  String selectedLanguage = "Auto Detect"; // Kullanıcının seçtiği dil
  String youtubeUrl = ""; // YouTube URL
  bool isLoading = false; // Yükleme durumu
  String loadingMessage = "Loading YouTube video"; // Yükleme mesajı

  void showLanguageMenu(BuildContext context, Offset position) async {
    // Dil seçim menüsü fonksiyonu buraya gelebilir.
  }

  Future<void> handleContinue() async {
    if (youtubeUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid YouTube URL")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Yükleme ekranını göster
      loadingMessage = "Processing your request...";
    });

    try {
      final apiService = ApiService(); // API servisini başlat
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

      // Firestore'da kartın isGenerated durumunu güncelle
      final homeController = Provider.of<HomeController>(context, listen: false);
      await homeController.markCardAsGenerated(widget.cardId);

      // Firestore'daki kartın summary bölümünü güncelle
      await homeController.updateCardSummary(
        widget.cardId,
        result['flow_name'] ?? 'Generated Title',
        result['step_results']?[1]['output'] ?? 'No Summary Available',
        result['step_results']?[0]['output'] ?? 'No Transcript Available',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubeSummaryPage(
            title: result['flow_name'] ?? 'Generated Title',
            timestamp: DateTime.now().toString(),
            summary: result['step_results']?[1]['output'] ?? 'No Summary Available',
            transcript: result['step_results']?[0]['output'] ?? 'No Transcript Available',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false; // Yükleme ekranını kapat
      });
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
                      youtubeUrl = value; // Kullanıcı URL girince kaydet
                    });
                  },
                  onPaste: () {
                    print("Paste Button Tapped");
                  },
                ),
                const SizedBox(height: 24),
                // Dil Seçim Başlığı
                const Text(
                  "Note Language",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Dil Seçim Widget'ı
                NoteLanguageSelector(
                  selectedLanguage: selectedLanguage,
                  onShowMenu: (position) => showLanguageMenu(context, position),
                ),
                const Spacer(),
                // Devam Butonu
                ContinueButton(onPressed: () => handleContinue()),
              ],
            ),
          ),
          // Yükleme Ekranı
          if (isLoading) LoadingOverlay(loadingMessage: loadingMessage),
        ],
      ),
    );
  }
}
