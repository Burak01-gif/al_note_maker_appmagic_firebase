import 'package:flutter/material.dart';

class NoteLanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(Offset) onShowMenu;

  const NoteLanguageSelector({
    Key? key,
    required this.selectedLanguage,
    required this.onShowMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        onShowMenu(details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedLanguage,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
