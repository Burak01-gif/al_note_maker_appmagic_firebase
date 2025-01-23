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
      // Yeni UUID oluştur ve kaydet
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
      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        return false; // Kullanıcı daha önce giriş yapmış
      } else {
        // Yeni kullanıcı kaydet
        await userDoc.set({
          'deviceId': deviceId,
          'firstLogin': true,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return true; // Yeni kullanıcı
      }
    } catch (e) {
      print("Firestore hatası: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Veriler yüklenirken gösterilecek
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          // Hata durumunda onboarding sayfasına git
          print("Error: ${snapshot.error}");
          return const Onboarding1();
        }

        if (snapshot.hasData) {
          if (snapshot.data == true) {
            // Yeni kullanıcı onboarding sayfasına yönlendirilecek
            return const Onboarding1();
          } else {
            // Daha önce giriş yapılmış, ana sayfaya yönlendir
            return const HomePage(showDialog: false);
          }
        } else {
          // Veri alınamazsa varsayılan olarak onboarding sayfasına yönlendir
          return const Onboarding1();
        }
      },
    );
  }
}
