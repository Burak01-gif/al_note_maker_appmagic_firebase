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