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
        'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
        'deviceId': data['deviceId'],
      });
    }
    notifyListeners();
  });
}


 /// Yeni bir kart ekler
Future<void> addCard(String? folderId, {bool isYouTube = false}) async {
  print("addCard called with folderId: $folderId, isYouTube: $isYouTube");

  if (_userId == null) {
    print("User ID is null. Cannot add card.");
    return;
  }

  String title;
  String type;

  if (isYouTube) {
    title = "YouTube Import";
    type = "youtube"; // YouTube türü
  } else {
    title = folderId == null ? "New Note" : "New Note in Folder";
    type = "audio"; // Ses türü
  }

  // Eğer folderId varsa hangi folder'a eklendiğini logla
  if (folderId != null) {
    print("This card will be added to the folder with ID: $folderId");
  } else {
    print("This card is not associated with any folder (it is independent).");
  }

  print("Preparing to add card with title: $title, type: $type");

  try {
    final docRef = await FirebaseFirestore.instance.collection('cards').add({
      'deviceId': _userId,
      'title': title,
      'isFavorite': false,
      'folderId': folderId,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("Card added to Firestore with ID: ${docRef.id}");

    _cards.add({
      'id': docRef.id,
      'title': title,
      'isFavorite': false,
      'folderId': folderId,
      'type': type,
      'deviceId': _userId,
      'createdAt': DateTime.now(),
    });

    print("Card added to local _cards list: ${_cards.last}");
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

  /// Filtrelenmiş kartları döndürür
  List<Map<String, dynamic>> getFilteredCards() {
    if (_selectedIndex == 2) {
      return _cards.where((card) => card['isFavorite'] == true).toList();
    } else if (_selectedIndex == 1) {
      return _cards.where((card) => card['folderId'] != null).toList();
    } else {
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
