import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_note_maker_appmagic/pages/youtube_pages/youtube.dart'; // YouTubePage dosyasının yolu

void showOptions(BuildContext context, Function onAddCard) {
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
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            onAddCard(); // Audio kaydı eklemek için işlem
          },
          child: const Text(
            'Record an Audio',
            style: TextStyle(color: Colors.blue), // Mavi renk
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            // YouTube sayfasına yönlendirme
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const YouTubePage(),
              ),
            );
          },
          child: const Text(
            'Import from Youtube',
            style: TextStyle(color: Colors.blue), // Mavi renk
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.blue), // Mavi renk
        ),
      ),
    ),
  );
}
