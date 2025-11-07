import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_nav_screen.dart';
import 'firebase_options.dart'; // se genera al configurar Firebase
import 'config/theme.dart';
import 'utils/firestore_seed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // await runFirestoreSeed(); // Ya ejecutado, comentar para no re-seed
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EstacionaUNSA', // Argumento movido
      theme: appTheme,         // Argumento movido
      home: const MainNavScreen(),
    );
  }
}

