import 'package:al_note_maker_appmagic/functions/home/home_controller.dart';
import 'package:al_note_maker_appmagic/pages/home_pages/home.dart';
import 'package:al_note_maker_appmagic/pages/onboarding_pages/onboarding1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Al Note Maker Appmagic',
      debugShowCheckedModeBanner: false,
      home: Initializer(),
    );
  }
}

class Initializer extends StatelessWidget {
  const Initializer({super.key});

  // Kalıcı bir UUID oluşturma ve saklama
  Future<String> _getPersistentUUID() async {
    const uuid = Uuid();
    final prefs = await SharedPreferences.getInstance();

    // Daha önce kaydedilmiş bir UUID var mı?
    String? deviceId = prefs.getString('device_id');

    if (deviceId == null) {
      // Yoksa yeni bir UUID oluştur ve kaydet
      deviceId = uuid.v4();
      await prefs.setString('device_id', deviceId);
    }

    return deviceId;
  }

  Future<bool> _checkUserStatus() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Kalıcı UUID al ve cihaz ID olarak kullan
    final deviceId = await _getPersistentUUID();
    final userDoc = firestore.collection('users').doc(deviceId);

    try {
      // Kullanıcı belgesini kontrol et
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        // Daha önce giriş yapılmışsa
        return false; // Daha önce giriş yapmış kullanıcı
      } else {
        // İlk giriş, kullanıcıyı kaydet
        await userDoc.set({
          'deviceId': deviceId,
          'firstLogin': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return true; // İlk kez giriş yapan kullanıcı
      }
    } catch (e) {
      print("Firestore yazma hatası: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomePage(showDialog: snapshot.data!); 
        } else {
          return const Onboarding1(); 
        }
      },
    );
  }
}
