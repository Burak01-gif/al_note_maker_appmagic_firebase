import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showOptions(
    BuildContext context, Function(String? folderId, {bool isYouTube}) onAddCard) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: const Text(
        'Choose a File Type',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      message: const Text(
        'How would you like to proceed?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        // Record an Audio seçeneği
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            onAddCard(null); // Bağımsız bir ses kaydı kartı oluştur
          },
          child: const Text(
            'Record an Audio',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        // Import from YouTube seçeneği
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            // YouTube kartını oluştur
            onAddCard(null, isYouTube: true);
          },
          child: const Text(
            'Import from YouTube',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
      // İptal butonu
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ),
  );
}
