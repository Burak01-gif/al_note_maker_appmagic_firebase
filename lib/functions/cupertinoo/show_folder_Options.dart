import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showFolderOptions({
  required BuildContext context,
  required String folderName,
  required int index,
  required VoidCallback onDelete,
}) async {
  final result = await showMenu<String>(
    context: context,
    position: const RelativeRect.fromLTRB(100, 120, 10, 10),
    items: [
      const PopupMenuItem<String>(
        value: 'delete',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Delete", style: TextStyle(color: Colors.red)),
            Icon(CupertinoIcons.delete, color: Colors.red),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'cancel',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Cancel"),
            Icon(CupertinoIcons.clear),
          ],
        ),
      ),
    ],
  );

  if (result == 'delete') {
    onDelete();
  }
}


void showAddFolderDialog({
  required BuildContext context,
  required TextEditingController folderNameController,
  required Function(String folderName) onCreate,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('New Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text('Enter the name for the new folder'),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: folderNameController,
              placeholder: 'Folder Name',
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              folderNameController.clear();
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Create'),
            onPressed: () {
              final folderName = folderNameController.text.trim();
              if (folderName.isNotEmpty) {
                onCreate(folderName);
              }
              folderNameController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
