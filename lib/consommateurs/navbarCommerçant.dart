import 'package:flutter/material.dart';
import 'package:meal_flavor/consommateurs/accueil.dart';
import 'package:meal_flavor/consommateurs/scanner.dart'; // Vérifie que le code que tu as posté est BIEN dans ce fichier
import 'package:meal_flavor/consommateurs/profil.dart';
//import 'package:meal_flavor/consommateurs/stock.dart';
import 'package:meal_flavor/consommateurs/ajouter.dart';

class MainNavigationCommercant extends StatefulWidget {
  const MainNavigationCommercant({super.key});

  @override
  State<MainNavigationCommercant> createState() => _MainNavigationCommercantState();
}

class _MainNavigationCommercantState extends State<MainNavigationCommercant> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardCommercant(), // Accueil
    const AjouterPanierPage(),  // Ajouter
    const ScannerPage(), // Scanner (Central)
    const Center(child: Text("Gestion du Stock")),          // Stock
    const ProfilCommercantPage(),  // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Ajouter'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Stock'),
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Profil'),
        ],
      ),
    );
  }
}