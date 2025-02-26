import 'package:al_note_maker_appmagic/functions/provider/home_controller.dart';
import 'package:al_note_maker_appmagic/pages/home_pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YouTubeSummaryPage extends StatelessWidget {
  final String title;
  final String timestamp;
  final String summary;
  final String transcript;
  final String cardId;

  const YouTubeSummaryPage({
    Key? key,
    required this.title,
    required this.timestamp,
    required this.summary,
    required this.transcript,
    required this.cardId,
  }) : super(key: key);

  void _showFolderSelectionMenu(BuildContext context, TapDownDetails details) async {
  final homeController = Provider.of<HomeController>(context, listen: false);

  final selectedFolder = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      details.globalPosition.dx, // X koordinatı
      details.globalPosition.dy, // Y koordinatı
      details.globalPosition.dx + 1,
      details.globalPosition.dy + 50,
    ),
    items: [
      const PopupMenuItem<String>(
        value: null,
        child: Text("No Folder", style: TextStyle(color: Colors.red)),
      ),
      ...homeController.folders.map((folder) {
        return PopupMenuItem<String>(
          value: folder['id'],
          child: Text(folder['name']),
        );
      }).toList(),
    ],
  );

  if (selectedFolder != null) {
    await homeController.moveCardToFolder(cardId, selectedFolder);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Moved to folder successfully!")),
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
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage(showDialog: false)),
              (Route<dynamic> route) => false,
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

            // Zaman Damgası ve Klasöre Ekleme
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
                  onTapDown: (TapDownDetails details) {
                       _showFolderSelectionMenu(context, details);
                        },
                  child: const Row(
                    children: [
                      Icon(Icons.folder, size: 19, color: Color(0xFF5584EC)),
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
                    "YouTube Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
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
                      color: Colors.orange,
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
            const SizedBox(height: 20),

            // Silme Butonu
            Padding(
      padding: const EdgeInsets.fromLTRB(87.5, 16, 16, 0),
      child: SizedBox(
        width: 200,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {
  final homeController = Provider.of<HomeController>(context, listen: false);
  
  homeController.deleteCard(cardId.trim()).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card deleted successfully!')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage(showDialog: false)),
      (Route<dynamic> route) => false,
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete card: $error')),
    );
  });
},

          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF9FAFB),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
