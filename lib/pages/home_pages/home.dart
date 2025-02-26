import 'package:al_note_maker_appmagic/cupertino/show_add_folder_dialog.dart';
import 'package:al_note_maker_appmagic/cupertino/show_folder_Options.dart';
import 'package:al_note_maker_appmagic/functions/provider/home_controller.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/congratulations_dialog.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/home_folders/empty_state_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/home_folders/buildFoldersView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_note_maker_appmagic/pages/folder_pages/folder.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/custom_appbar.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/tab_bar_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/content_cards_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/show_create_note_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/search_bar_widget.dart';
import 'package:al_note_maker_appmagic/cupertino/showOptions.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/home_folders/youtube_view_widget.dart';

class HomePage extends StatelessWidget {
  final bool showDialog;

  const HomePage({super.key, required this.showDialog});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Your Files',
            onSettingsTap: () {
              print("Settings tapped");
            },
          ),
          body: Column(
            children: [
              // Arama çubuğu
              SearchBarWidget(
                hintText: 'Search',
                onChanged: (value) {
                  Provider.of<HomeController>(context, listen: false).searchCards(value);
                  print('Search: $value');
                },
              ),
              // Sekme çubuğu
              TabBarWidget(
                tabTitles: const ['All', 'Folders', 'Favorites', 'Youtube'],
                selectedIndex: controller.selectedIndex,
                onTabSelect: controller.updateSelectedIndex,
              ),
              // İçerik alanı
              Expanded(
                child: controller.selectedIndex == 1
                    ? buildFoldersView(
                        context: context,
                        folders: controller.folders
                            .map((folder) => folder['name'] as String)
                            .toList(),
                        folderNameController: TextEditingController(),
                        onAddFolder: (folderName) async {
                          await controller.addFolder(folderName);
                        },
                        onDeleteFolder: (index) async {
                          final folderId =
                              controller.folders[index]['id'] as String;
                          await controller.deleteFolder(folderId);
                        },
                        showAddFolderDialog: ({
                          required BuildContext context,
                          required TextEditingController folderNameController,
                          required Function(String folderName) onCreate,
                        }) {
                          showAddFolderDialog(
                            context: context,
                            folderNameController: folderNameController,
                            onCreate: onCreate,
                          );
                        },
                        showFolderOptions: ({
                          required BuildContext context,
                          required String folderName,
                          required int index,
                          required VoidCallback onDelete,
                          required Offset position,
                        }) {
                          final folderId =
                              controller.folders[index]['id'] as String;
                          showFolderOptions(
                            context: context,
                            folderName: folderName,
                            index: index,
                            onDelete: () async {
                              await controller.deleteFolder(folderId);
                            },
                          );
                        },
                        onFolderTap: (folderName) {
                          final folderId = controller.folders.firstWhere(
                            (folder) => folder['name'] == folderName,
                          )['id'] as String;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FolderPage(
                                folderId: folderId,
                                folderName: folderName,
                              ),
                            ),
                          );
                        },
                      )
                    : controller.selectedIndex == 3
                        ? YouTubeViewWidget()
                        : controller.getFilteredCards().isEmpty
                            ? EmptyStateWidget(
                                selectedIndex: controller.selectedIndex)
                            : ContentCardsWidget(
                                cards: controller.filteredCards.isEmpty
                                    ? controller.getFilteredCards()
                                    : controller.filteredCards,
                                selectedIndex: controller.selectedIndex,
                                onDelete: (index) async {
                                  final cardId =
                                      controller.cards[index]['id'] as String;
                                  await controller.deleteCard(cardId);
                                },
                                onToggleFavorite: (index) async {
                                  final cardId =
                                      controller.cards[index]['id'] as String;
                                  await controller.toggleFavorite(cardId);
                                },
                              ),
              ),
            ],
          ),
          bottomNavigationBar: showCreateNoteButton(
            context,
            () => showOptions(
              context,
              (String? folderId, {bool isYouTube = false}) async {
                await controller.addCard(folderId, isYouTube: isYouTube);
              },
            ),
          ),
        ),

        // CongratulationsDialog Dialog
        if (showDialog)
          CongratulationsDialog(
            onClose: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(showDialog: false),
                ),
              );
            },
          ),
      ],
    );
  }
}
