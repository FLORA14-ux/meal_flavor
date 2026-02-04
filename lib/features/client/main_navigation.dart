import 'package:flutter/material.dart';
import 'package:meal_flavor/features/client/navbar_client.dart'; // Import de ta nouvelle navbar
// Importe tes pages ici dès qu'elles sont créées :
// ignore: unused_import
import 'package:meal_flavor/features/home/accueil.dart'; 
// ignore: unused_import
import 'package:meal_flavor/features/client/carte.dart';
// ignore: unused_import
import 'package:meal_flavor/features/client/panier.dart';
// ignore: unused_import
import 'package:meal_flavor/features/profile/client_profil.dart';
// ignore: unused_import
import 'package:meal_flavor/features/client/detail_panier.dart';
// ignore: unused_import
import 'package:meal_flavor/features/client/commandes.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Liste des pages de MealFlavor
  final List<Widget> _pages = [
    const AccueilPage(), // Ta vraie page maintenant !
    const CartePage(),
    const PanierPage(),
    const ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Affiche la page correspondant à l'index actuel
      body: _pages[_currentIndex],
      
      // Utilise ta navbar personnalisée
      bottomNavigationBar: NavbarClient(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}