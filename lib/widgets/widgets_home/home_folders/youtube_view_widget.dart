import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_note_maker_appmagic/functions/provider/home_controller.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/content_cards_widget.dart';

/// Widget to display the YouTube tab's state.
class YouTubeViewWidget extends StatelessWidget {
  const YouTubeViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final youtubeCards = controller.cards.where((card) => card['type'] == 'youtube').toList();

    return youtubeCards.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_outline, size: 100, color: Colors.red[300]),
                const SizedBox(height: 16),
                const Text(
                  "No YouTube Imports Yet",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Use Lorem to Summarize YouTube Videos",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : ContentCardsWidget(
            cards: youtubeCards,
            selectedIndex: 3,
            onDelete: (index) async {
              final cardId = youtubeCards[index]['id'] as String;
              await controller.deleteCard(cardId);
            },
            onToggleFavorite: (index) async {
              final cardId = youtubeCards[index]['id'] as String;
              await controller.toggleFavorite(cardId);
            },
          );
  }
}
