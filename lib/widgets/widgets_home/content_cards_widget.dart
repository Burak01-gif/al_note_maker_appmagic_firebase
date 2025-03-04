import 'package:al_note_maker_appmagic/functions/provider/home_controller.dart';
import 'package:al_note_maker_appmagic/pages/recording_pages/recording_pages1.dart';
import 'package:al_note_maker_appmagic/pages/recording_pages/sumaarypages.dart';
import 'package:al_note_maker_appmagic/pages/youtube_pages/youtube.dart';
import 'package:al_note_maker_appmagic/pages/youtube_pages/youtubeSummaryPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContentCardsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cards;
  final int selectedIndex;
  final Function(int) onDelete;
  final Function(int) onToggleFavorite;

  const ContentCardsWidget({
    Key? key,
    required this.cards,
    required this.selectedIndex,
    required this.onDelete,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cards.isEmpty && (selectedIndex == 0 || selectedIndex == 2)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/home/home_mic.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              Text(
                selectedIndex == 2 ? 'No Favorites Yet' : 'No Audio Files Yet',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Start recording or import audio files to see them here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          )
        : cards.isEmpty
            ? const SizedBox()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  print("Card Data: $card");
                  final createdDate = card['createdAt'] != null
                      ? DateFormat('EEEE h:mm a')
                          .format(card['createdAt'] as DateTime)
                      : 'Unknown Time';

                  return GestureDetector(
onTap: () async {
  final cardId = card['id'];
  final controller = Provider.of<HomeController>(context, listen: false);

  final cardDetails = await controller.getCardDetailsWithStatus(cardId);

  if (cardDetails != null && cardDetails['isGenerated'] == true) {
    // Eğer kart daha önce işlendi ise doğru özet sayfasına yönlendir
    if (card['type'] == 'youtube') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubeSummaryPage(
            title: cardDetails['title'] ?? 'No Title',
            timestamp: DateTime.now().toString(),
            summary: cardDetails['summary'] ?? 'No Summary Available',
            transcript: cardDetails['transcript'] ?? 'No Transcript Available',
            cardId: cardId,
          ),
        ),
      );
    } else if (card['type'] == 'audio') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryPage(
            title: cardDetails['title'] ?? 'No Title',
            timestamp: DateTime.now().toString(),
            summary: cardDetails['summary'] ?? 'No Summary Available',
            transcript: cardDetails['transcript'] ?? 'No Transcript Available',
            type: 'audio',
            cardId: cardId,
          ),
        ),
      );
    }
  } else {
    // Eğer özet oluşturulmadıysa ilgili işlem sayfasına yönlendir
    if (card['type'] == 'youtube') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubePage(cardId: cardId),
        ),
      );
    } else if (card['type'] == 'audio') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecordingPage1(
            title: card['title'] ?? 'Untitled Note',
            folderName: card['folderName'] ?? 'All',
            cardId: cardId,
          ),
        ),
      );
    }
  }
},



                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 112.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
  (card['type'] ?? 'audio') == 'youtube'
      ? Icons.video_library
      : Icons.mic,
  size: 28.0,
  color: (card['type'] ?? 'audio') == 'youtube'
      ? Colors.red
      : const Color(0xFF5584EC),
),                                        
                                      const SizedBox(height: 8),
                                      Text(
                                        card['title'] ?? 'Untitled Note',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0,
                                          color: Color(0xFF010101),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Created: $createdDate',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.0,
                                          color: Color(0xFF9F9F9F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
  top: 8.0,
  right: 8.0,
  child: GestureDetector(
    onTapDown: (TapDownDetails details) {
      final position = details.globalPosition;
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          position.dx + 1,
          position.dy + 1,
        ),
        items: [
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                const Icon(Icons.cancel, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ).then((value) {
        if (value == 'delete') {
          onDelete(index);
        }
      });
    },
    child: const Icon(
      Icons.more_vert,
      color: Colors.grey,
    ),
  ),
),

                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              onToggleFavorite(index);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  card['isFavorite']
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Tap to Add Favorites',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF010101),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
