import 'package:al_note_maker_appmagic/functions/cupertinoo/show_folder_Options.dart';
import 'package:al_note_maker_appmagic/functions/home/home_controller.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/home_folders/empty_state_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/home_folders/widget_home_folder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_note_maker_appmagic/pages/home_pages/folder.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/custom_appbar.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/tab_bar_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/content_cards_widget.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/show_create_note_button.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/search_bar_widget.dart';
import 'package:al_note_maker_appmagic/functions/cupertinoo/showOptions.dart';
import 'package:al_note_maker_appmagic/widgets/widgets_home/home_folders/youtube_view_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Scaffold(
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
                    folders: controller.folders,
                    folderNameController: TextEditingController(),
                    onAddFolder: controller.addFolder,
                    onDeleteFolder: (index) => controller.deleteFolder(index),
                    showAddFolderDialog: ({
                      required BuildContext context,
                      required TextEditingController folderNameController,
                      required Function(String folderName) onCreate,
                    }) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Add Folder"),
                            content: TextField(
                              controller: folderNameController,
                              decoration: const InputDecoration(
                                hintText: "Folder Name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  final folderName =
                                      folderNameController.text.trim();
                                  if (folderName.isNotEmpty) {
                                    onCreate(folderName);
                                    folderNameController.clear();
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    showFolderOptions: ({
                      required BuildContext context,
                      required String folderName,
                      required int index,
                      required VoidCallback onDelete,
                    }) {
                      showFolderOptions(
                        context: context,
                        folderName: folderName,
                        index: index,
                        onDelete: onDelete,
                      );
                    },
                    onFolderTap: (folderName) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FolderPage(
                            folderName: folderName,
                          ),
                        ),
                      );
                    },
                  )
                : controller.selectedIndex == 3
                    ? YouTubeViewWidget(context)
                    : controller.getFilteredCards().isEmpty
                        ? EmptyStateWidget(selectedIndex: controller.selectedIndex)
                        : ContentCardsWidget(
                            cards: controller.getFilteredCards(),
                            selectedIndex: controller.selectedIndex,
                            onDelete: controller.deleteCard,
                            onToggleFavorite: controller.toggleFavorite,
                          ),
          ),
        ],
      ),
      bottomNavigationBar: showCreateNoteButton(
        context,
        () => showOptions(
          context,
          () => controller.addCard(null),
        ),
      ),
    );
  }
}
