import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  final List<Map<String, dynamic>> _cards = [];
  final List<Map<String, dynamic>> _folders = [];
  int _selectedIndex = 0;
  String? _userId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> get cards => List.unmodifiable(_cards);
  List<Map<String, dynamic>> get folders => List.unmodifiable(_folders);
  int get selectedIndex => _selectedIndex;

  String get userId => _userId ?? '';

  HomeController() {
    _initializeUserId().then((_) {
      _listenToFolders();
      _listenToCards();
    });
  }

  /// Kullanıcı ID'sini başlatır
  Future<void> _initializeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userId');

    if (storedUserId == null) {
      const uuid = Uuid();
      storedUserId = uuid.v4();
      await prefs.setString('userId', storedUserId);

      // Firestore'da kullanıcıyı kaydet
      await FirebaseFirestore.instance.collection('users').doc(storedUserId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'device': kIsWeb ? 'web' : 'mobile',
      });
    }

    _userId = storedUserId;
    notifyListeners();
  }

  /// Kullanıcı durumunu kontrol et
  Future<bool> checkUserStatus() async {
    if (_userId == null) await _initializeUserId();

    try {
      final doc = await firestore.collection('users').doc(_userId).get();
      return doc.exists;
    } catch (e) {
      print("Firestore kullanıcı durumu kontrol hatası: $e");
      return false;
    }
  }

/// Klasörleri gerçek zamanlı dinler
void _listenToFolders() {
  if (_userId == null) return;

  FirebaseFirestore.instance
      .collection('folders')
      .where('deviceId', isEqualTo: _userId)
      .orderBy('createdAt', descending: false)
      .snapshots()
      .listen((querySnapshot) {
    _folders.clear();
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      _folders.add({
        'id': doc.id,
        'name': data['name'],
        'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
        'deviceId': data['deviceId'],
      });
    }
    notifyListeners();
  });
}

/// Kartları gerçek zamanlı dinler
void _listenToCards() {
  if (_userId == null) return;

  FirebaseFirestore.instance
      .collection('cards')
      .where('deviceId', isEqualTo: _userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .listen((querySnapshot) {
    _cards.clear();
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      _cards.add({
        'id': doc.id,
        'title': data['title'],
        'isFavorite': data['isFavorite'],
        'folderId': data['folderId'],
        'type': data['type'] ?? 'audio', // Default olarak 'audio'
        'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
        'deviceId': data['deviceId'],
      });
    }
    notifyListeners();
  });
}



 /// Yeni bir kart ekler
Future<void> addCard(String? folderId, {bool isYouTube = false}) async {
  if (_userId == null) return;

  String title = isYouTube ? "YouTube Import" : "New Note";
  String type = isYouTube ? "youtube" : "audio";

  try {
    final docRef = await FirebaseFirestore.instance.collection('cards').add({
      'deviceId': _userId,
      'title': title,
      'type': type, // Type alanı doğru gönderiliyor
      'isFavorite': false,
      'folderId': folderId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _cards.add({
      'id': docRef.id,
      'title': title,
      'type': type, // Type doğru şekilde ekleniyor
      'isFavorite': false,
      'folderId': folderId,
      'deviceId': _userId,
      'createdAt': DateTime.now(),
    });
    notifyListeners();
  } catch (e) {
    print("Failed to add card: $e");
  }
}


Future<void> addFolder(String folderName) async {
  if (_userId == null) return;

  try {
    final docRef = await FirebaseFirestore.instance.collection('folders').add({
      'deviceId': _userId,
      'name': folderName,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _folders.add({
      'id': docRef.id,
      'name': folderName,
      'deviceId': _userId,
      'createdAt': DateTime.now(),
    });
    notifyListeners();
  } catch (e) {
    print("Failed to add folder: $e");
  }
}

  /// Klasörü ve ilişkili kartları siler
  Future<void> deleteFolder(String folderId) async {
    if (_userId == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cards')
          .where('folderId', isEqualTo: folderId)
          .where('deviceId', isEqualTo: _userId)
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance.collection('cards').doc(doc.id).delete();
      }

      await FirebaseFirestore.instance.collection('folders').doc(folderId).delete();

      _folders.removeWhere((folder) => folder['id'] == folderId);
      _cards.removeWhere((card) => card['folderId'] == folderId);
      notifyListeners();
    } catch (e) {
      print("Failed to delete folder: $e");
    }
  }

  /// Bir kartı siler
  Future<void> deleteCard(String cardId) async {
    if (_userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('cards').doc(cardId).delete();

      _cards.removeWhere((card) => card['id'] == cardId);
      notifyListeners();
    } catch (e) {
      print("Failed to delete card: $e");
    }
  }

  /// Kartın favori durumunu değiştirir
  Future<void> toggleFavorite(String cardId) async {
    if (_userId == null) return;

    try {
      final card = _cards.firstWhere((card) => card['id'] == cardId);
      final newFavoriteStatus = !(card['isFavorite'] as bool);

      await FirebaseFirestore.instance.collection('cards').doc(cardId).update({
        'isFavorite': newFavoriteStatus,
      });

      card['isFavorite'] = newFavoriteStatus;
      notifyListeners();
    } catch (e) {
      print("Failed to toggle favorite: $e");
    }
  }

  List<Map<String, dynamic>> getFilteredCards() {
  if (_selectedIndex == 2) {
    // Favoriler
    return _cards.where((card) => card['isFavorite'] == true).toList();
  } else if (_selectedIndex == 3) {
    // YouTube
    return _cards.where((card) => card['type'] == 'youtube').toList();
  } else {
    // Tüm kartlar
    return _cards;
  }
}


  /// Sekme indeksini günceller
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateFolderCards(String folderName, List<Map<String, dynamic>> folderCards) {}

  
}
