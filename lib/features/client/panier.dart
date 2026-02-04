import 'package:flutter/material.dart';
import 'package:meal_flavor/features/client/commandes.dart';

class Panier {
  final String id;
  final String nom;
  final String categorie;
  final String imageUrl;
  final double prixOriginal;
  final double prixReduit;
  final int reduction;
  final String contenuPanier;
  final String heureRetrait;
  final String adresseRetrait;
  final double distance;
  final int paniersDisponibles;

  Panier({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.imageUrl,
    required this.prixOriginal,
    required this.prixReduit,
    required this.reduction,
    required this.contenuPanier,
    required this.heureRetrait,
    required this.adresseRetrait,
    required this.distance,
    required this.paniersDisponibles,
  });
}

class PanierPage extends StatelessWidget {
  const PanierPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirige vers MesCommandesPage
    return const MesCommandesPage();
  }
}