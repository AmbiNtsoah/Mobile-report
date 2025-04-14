import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:report_internship/firebase_options.dart';
import 'authentification/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Choisis quelle plateforme l'application va être lancé
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login(), debugShowCheckedModeBanner: false);
  }
}
