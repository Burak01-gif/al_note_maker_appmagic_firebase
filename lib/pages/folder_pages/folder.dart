import 'package:al_note_maker_appmagic/cupertino/showOptions.dart';
import 'package:al_note_maker_appmagic/functions/provider/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/content_cards_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/show_create_note_button.dart';

class FolderPage extends StatelessWidget {
  final String folderId;
  final String folderName;

  const FolderPage({super.key, required this.folderId, required this.folderName});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final folderCards = controller.cards
        .where((card) => card['folderId'] == folderId)
        .toList();
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
        title: Text(
          folderName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showFolderOptions(context, details.globalPosition, controller);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: folderCards.isEmpty
          ? const Center(
              child: Text(
                "No notes in this folder yet!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ContentCardsWidget(
              cards: folderCards,
              selectedIndex: 0,
              onDelete: (index) async {
                final cardId = folderCards[index]['id'] as String;
                await controller.deleteCard(cardId);
              },
              onToggleFavorite: (index) async {
                final cardId = folderCards[index]['id'] as String;
                await controller.toggleFavorite(cardId);
              },
            ),
      bottomNavigationBar: showCreateNoteButton(
  context,
  () => showOptions(
    context,
    (String? id, {bool isYouTube = false}) async {
      print("FolderPage folderId: $folderId"); // Loglama
      await controller.addCard(folderId, isYouTube: isYouTube); // folderId doğru aktarılıyor
    },
  ),
),


    );
  }

  void _showFolderOptions(
      BuildContext context, Offset position, HomeController controller) {
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
          child: const Text("Rename Folder"),
          onTap: () {
            print("Rename Folder");
            // Buraya klasör ismini değiştirme işlevi eklenebilir
          },
        ),
        PopupMenuItem(
          child: const Text("Delete Folder"),
          onTap: () async {
            await controller.deleteFolder(folderId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
