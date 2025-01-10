import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Folders grid view oluşturur.
/// [folders] klasör isimlerini içeren liste.
/// [folderNameController] yeni klasör için text controller.
/// [onAddFolder] yeni klasör ekleme callback'i.
/// [onDeleteFolder] klasör silme callback'i.
/// [showAddFolderDialog] yeni klasör ekleme dialog gösterimi için callback.
/// [showFolderOptions] klasör seçenekleri menüsünü göstermek için callback.

Widget buildFoldersView({
  required BuildContext context,
  required List<String> folders,
  required TextEditingController folderNameController,
  required Function(String folderName) onAddFolder,
  required Function(int index) onDeleteFolder,
  required void Function({
    required BuildContext context,
    required TextEditingController folderNameController,
    required Function(String folderName) onCreate,
  }) showAddFolderDialog,
  required void Function({
    required BuildContext context,
    required String folderName,
    required int index,
    required VoidCallback onDelete,
  }) showFolderOptions,
  required Function(String folderName) onFolderTap,
}) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.8,
    ),
    itemCount: folders.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                showAddFolderDialog(
                  context: context,
                  folderNameController: folderNameController,
                  onCreate: onAddFolder,
                );
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Add Folder",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        );
      }

      final folderName = folders[index - 1];
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              onFolderTap(folderName);
            },
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.folder,
                  size: 50,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    folderName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showFolderOptions(
                      context: context,
                      folderName: folderName,
                      index: index,
                      onDelete: () {
                        onDeleteFolder(index);
                      },
                    );
                  },
                  child: const Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
