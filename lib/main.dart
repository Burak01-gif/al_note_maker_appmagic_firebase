import 'package:al_note_maker_appmagic/functions/home/home_controller.dart';
import 'package:al_note_maker_appmagic/pages/home_pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: HomePage(),
    );
  }
}
