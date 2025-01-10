import 'package:al_note_maker_appmagic/functions/cupertinoo/show_delete_dialog.dart';
import 'package:al_note_maker_appmagic/pages/recording_pages/recording_pages1.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

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
                  final createdDate = card['createdAt'] != null
                      ? DateFormat('EEEE h:mm a')
                          .format(card['createdAt'] as DateTime)
                      : 'Unknown Time';

                  return GestureDetector(
                    onTap: () {
                      // Karta tıklandığında RecordingPage'e yönlendirme yapar.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordingPage1(
                            title: card['title'] ?? 'Untitled Note',
                            folderName: card['folderName'] ?? 'All',
                          ),
                        ),
                      );
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
                                      const Icon(
                                        Icons.mic,
                                        size: 28.0,
                                        color: Color(0xFF5584EC),
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
                                  child: IconButton(
                                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                                    onPressed: () {
                                      showDeleteDialog(
                                        context,
                                        (int realIndex) {
                                          onDelete(index);
                                        },
                                        index,
                                      );
                                    },
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
