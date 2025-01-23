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

 Future<void> addCard(String? folderId, {bool isYouTube = false}) async {
  if (_userId == null) return;

  String title = isYouTube ? "YouTube Import" : "New Note";
  String type = isYouTube ? "youtube" : "audio";

  try {
    final docRef = await FirebaseFirestore.instance.collection('cards').add({
      'deviceId': _userId,
      'title': title,
      'type': type,
      'isFavorite': false,
      'isGenerated': false,  
      'folderId': folderId ?? '',  // folderId null ise boş string olarak kaydet
      'createdAt': FieldValue.serverTimestamp(),
    });

    await docRef.collection('summaries').doc('default_summary').set({
      'title': null,
      'summary': null,
      'transcript': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _cards.add({
      'id': docRef.id,
      'title': title,
      'type': type,
      'isFavorite': false,
      'isGenerated': false,
      'folderId': folderId ?? '',
      'deviceId': _userId,
      'createdAt': DateTime.now(),
    });
    
    notifyListeners();
    print("Card added successfully with ID: ${docRef.id}");
  } catch (e) {
    print("Failed to add card: $e");
  }
}

Future<void> addCardWithVerification(String? folderId, {bool isYouTube = false}) async {
  await addCard(folderId, isYouTube: isYouTube);

  final snapshot = await FirebaseFirestore.instance.collection('cards')
      .where('deviceId', isEqualTo: _userId)
      .orderBy('createdAt', descending: true)
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    print("Successfully verified card in Firestore: ${snapshot.docs.first.data()}");
  } else {
    print("Failed to verify card in Firestore");
  }
}



Future<void> markCardAsGenerated(String cardId) async {
  try {
    await FirebaseFirestore.instance.collection('cards').doc(cardId).update({
      'isGenerated': true,
    });
    _cards.firstWhere((card) => card['id'] == cardId)['isGenerated'] = true;
    notifyListeners();
  } catch (e) {
    print("Failed to mark card as generated: $e");
  }
}

Future<Map<String, dynamic>?> getCardDetailsWithStatus(String cardId) async {
  try {
    // Firestore'dan kart verisini al
    DocumentSnapshot cardSnapshot = await FirebaseFirestore.instance
        .collection('cards')
        .doc(cardId)
        .get();

    if (!cardSnapshot.exists) {
      return null;
    }

    final cardData = cardSnapshot.data() as Map<String, dynamic>;

    // Kartın isGenerated durumunu kontrol et
    bool isGenerated = cardData['isGenerated'] ?? false;

    // Kartın özet verisini al
    var summarySnapshot = await FirebaseFirestore.instance
        .collection('cards')
        .doc(cardId)
        .collection('summaries')
        .doc('default_summary')
        .get();

    if (!summarySnapshot.exists) {
      return null;
    }

    final summaryData = summarySnapshot.data() as Map<String, dynamic>;

    return {
      'isGenerated': isGenerated,
      'title': summaryData['title'] ?? '',
      'summary': summaryData['summary'] ?? '',
      'transcript': summaryData['transcript'] ?? '',
    };
  } catch (e) {
    print("Error fetching card details with status: $e");
    return null;
  }
}

  Future<String?> addAudioCard(String? folderId) async {
  if (_userId == null) return null;

  try {
    final docRef = await FirebaseFirestore.instance.collection('cards').add({
      'deviceId': _userId,
      'title': "Recorded Audio",
      'type': 'audio',
      'isFavorite': false,
      'isGenerated': false,
      'folderId': folderId ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await docRef.collection('summaries').doc('default_summary').set({
      'title': null,
      'summary': null,
      'transcript': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _cards.add({
      'id': docRef.id,
      'title': "Recorded Audio",
      'type': 'audio',
      'isFavorite': false,
      'isGenerated': false,
      'folderId': folderId ?? '',
      'deviceId': _userId,
      'createdAt': DateTime.now(),
    });

    notifyListeners();
    print("Audio card added successfully with ID: ${docRef.id}");
    return docRef.id;  // Kartın Firestore ID'sini döndür
  } catch (e) {
    print("Failed to add audio card: $e");
    return null;
  }
}


  Future<void> markAudioAsGenerated(String cardId, String title, String summary, String transcript) async {
    try {
      await FirebaseFirestore.instance.collection('cards').doc(cardId).update({
        'isGenerated': true,
      });

      await FirebaseFirestore.instance.collection('cards').doc(cardId).collection('summaries').doc('default_summary').set({
        'title': title,
        'summary': summary,
        'transcript': transcript,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final card = _cards.firstWhere((card) => card['id'] == cardId);
      card['isGenerated'] = true;

      notifyListeners();
    } catch (e) {
      print("Failed to mark audio as generated: $e");
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

  Future<void> saveCardDetails(String cardId, String title, String summary, String transcript) async {
  try {
    await FirebaseFirestore.instance
        .collection('cards')
        .doc(cardId)
        .collection('summaries')
        .add({
      'title': title,
      'summary': summary,
      'transcript': transcript,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("Card details saved successfully.");
  } catch (e) {
    print("Error saving card details: $e");
  }
  }

  Future<Map<String, dynamic>?> getCardDetails(String cardId) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection('cards')
        .doc(cardId)
        .collection('summaries')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching card details: $e");
    return null;
  }
  }

 Future<void> updateCardSummary(String cardId, String? title, String? summary, String? transcript) async {
  try {
    await FirebaseFirestore.instance
        .collection('cards')
        .doc(cardId)
        .collection('summaries')
        .doc('default_summary')
        .set({
      'title': title?.isNotEmpty == true ? title : 'No Title',
      'summary': summary?.isNotEmpty == true ? summary : 'No Summary Available',
      'transcript': transcript?.isNotEmpty == true ? transcript : 'No Transcript Available',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    print("Card summary updated successfully.");
  } catch (e) {
    print("Error updating card summary: $e");
  }
}



}