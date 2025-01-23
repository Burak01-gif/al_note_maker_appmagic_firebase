import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_note_maker_appmagic/functions/home/home_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
   final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Search',
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          onChanged: (value) {
            Provider.of<HomeController>(context, listen: false).searchCards(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
