import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context, Offset position, Function(int) onDelete, int index) {
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
        child: const Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () {
          onDelete(index);
        },
      ),
      PopupMenuItem(
        child: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}
