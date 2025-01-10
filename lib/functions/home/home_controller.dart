import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  final List<Map<String, dynamic>> _cards = [];
  final List<String> _folders = [];
  int _selectedIndex = 0;

  List<Map<String, dynamic>> get cards => List.unmodifiable(_cards);
  List<String> get folders => List.unmodifiable(_folders);
  int get selectedIndex => _selectedIndex;

  List<Map<String, dynamic>> getFilteredCards() {
    if (_selectedIndex == 2) {
      return _cards.where((card) => card["isFavorite"] as bool).toList();
    } else if (_selectedIndex == 0) {
      return _cards;
    } else if (_selectedIndex == 1) {
      return _cards.where((card) => card['folderName'] != null).toList();
    }
    return [];
  }

  void addCard(String? folderName) {
    _cards.add({
      "title": "New Note",
      "isFavorite": false,
      "folderName": folderName,
      "createdAt": DateTime.now(),
    });
    notifyListeners();
  }

  void addFolder(String folderName) {
    _folders.add(folderName);
    notifyListeners();
  }

  void deleteFolder(int index) {
    _folders.removeAt(index);
    notifyListeners();
  }

  void deleteCard(int index) {
    _cards.removeAt(index);
    notifyListeners();
  }

  void toggleFavorite(int index) {
    _cards[index]['isFavorite'] = !(_cards[index]['isFavorite'] as bool);
    notifyListeners();
  }

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateFolderCards(String folderName, List<Map<String, dynamic>> updatedCards) {
    _cards.removeWhere((card) => card['folderName'] == folderName);
    _cards.addAll(updatedCards);
    notifyListeners();
  }
}
