import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
// Importe tes pages réelles ici
// import 'package:ton_projet/acceuil.dart';
// import 'package:ton_projet/carte.dart';
// import 'package:ton_projet/panier.dart';
// import 'package:ton_projet/profil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealFlavor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 21, 119, 21), // Ta couleur orange
          primary: const Color.fromARGB(255, 21, 119, 21),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      // C'est ici que tu définis l'écran de démarrage
      home: const SplashScreen(),
    );
  }
}
