import 'package:flutter/cupertino.dart';

void showDeleteDialog(BuildContext context, Function(int) onDelete, int index) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            onDelete(index);
            Navigator.pop(context);
          },
          isDestructiveAction: true, 
          child: const Text('Delete'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
    ),
  );
}

