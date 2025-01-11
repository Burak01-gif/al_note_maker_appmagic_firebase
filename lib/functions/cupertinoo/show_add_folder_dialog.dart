
import 'package:flutter/cupertino.dart';

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