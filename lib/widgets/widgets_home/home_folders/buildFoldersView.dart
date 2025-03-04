import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    required Offset position,  
  }) showFolderOptions,
  required Function(String folderName) onFolderTap,
}) {
  // Ekran genişliği
  final double screenWidth = MediaQuery.of(context).size.width;
  final int crossAxisCount = screenWidth > 600 ? 3 : 2; 

  return GridView.builder(
    padding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.05, 
      vertical: 16.0,
    ),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: screenWidth * 0.04,
      mainAxisSpacing: screenWidth * 0.04,
      childAspectRatio: screenWidth < 400 ? 0.75 : 0.85, 
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
                height: screenWidth * 0.4, 
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

      if (index - 1 < 0 || index - 1 >= folders.length) {
        return const SizedBox();
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
              height: screenWidth * 0.4,
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
  onTapDown: (TapDownDetails details) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    overlay.globalToLocal(details.globalPosition);
    // final Offset position = overlay.globalToLocal(details.globalPosition); 

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx, 
        details.globalPosition.dy,  
        details.globalPosition.dx + 1,  
        details.globalPosition.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete'),
          ),
        ),
        PopupMenuItem(
          value: 'cancel',
          child: ListTile(
            leading: Icon(Icons.cancel, color: Colors.grey),
            title: Text('Cancel'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete') {
        onDeleteFolder(index - 1);
      } else if (value == 'cancel') {
        Navigator.pop(context);  // Menü kapat
      }
    });
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
