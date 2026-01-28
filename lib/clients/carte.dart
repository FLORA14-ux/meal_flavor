import 'package:flutter/material.dart';

class CartePage extends StatelessWidget {
  const CartePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carte du Togo (Simulation)")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_rounded, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text("La carte Google Maps s'affichera ici"),
            const Text("après configuration de la clé API."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulation d'une recherche sur Lomé
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Recherche de commerçants à Lomé...")),
                );
              },
              child: const Text("Tester la recherche"),
            )
          ],
        ),
      ),
    );
  }
}