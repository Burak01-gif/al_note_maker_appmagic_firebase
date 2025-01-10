import 'package:al_note_maker_appmagic/widgets/widgets_home/build_tab_item.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final List<String> tabTitles;
  final int selectedIndex;
  final Function(int) onTabSelect;

  const TabBarWidget({
    Key? key,
    required this.tabTitles,
    required this.selectedIndex,
    required this.onTabSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabTitles.map((title) {
            int index = tabTitles.indexOf(title);
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CustomTabItem(
                title: title,
                isSelected: selectedIndex == index,
                onTap: () => onTabSelect(index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
