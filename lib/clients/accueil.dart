import 'package:flutter/material.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MealFlavor", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 21, 119, 21),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Offres anti-gaspi du jour 🍃",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Une carte d'exemple pour un repas
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.green, size: 40),
                title: const Text("Panier Surprise - Boulangerie Marie"),
                subtitle: const Text("Plus que 2 disponibles !"),
                trailing: const Text("4.50€", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}