import 'package:flutter/material.dart';

class DashboardCommercant extends StatelessWidget {
  const DashboardCommercant({super.key});

  @override
  Widget build(BuildContext context) {
    // Couleurs de ton design
    const Color orangeMeal = Color(0xFFFF9800);
    const Color greenSuccess = Color(0xFFE8F5E9);
    const Color textGrey = Color(0xFF757575);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER : Sélecteur Client/Commerçant & Déconnexion ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _buildTopTab("Client", false),
                      _buildTopTab("Commerçant", true),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Déconnexion", style: TextStyle(color: Colors.redAccent)),
                )
              ],
            ),
            const SizedBox(height: 25),

            // --- INFOS COMMERCE ---
            const Text("Tableau de bord", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Boulangerie Le Palmier", style: TextStyle(fontSize: 16, color: textGrey)),
            const SizedBox(height: 5),
            const Row(
              children: [
                Icon(Icons.phone, size: 14, color: textGrey),
                Text(" +228 90 12 34 56  ", style: TextStyle(color: textGrey)),
                Icon(Icons.location_on, size: 14, color: textGrey),
                Text(" Lomé", style: TextStyle(color: textGrey)),
              ],
            ),
            const SizedBox(height: 20),

            // --- BANNIÈRE DATE ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.access_time, color: orangeMeal),
                  SizedBox(width: 10),
                  Text("Aujourd'hui", style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text("mercredi 28 janvier"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- GRILLE DES STATISTIQUES (4 Cartes) ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3,
              children: [
                _buildInfoCard("Ventes du jour", "45 000 FCFA", Icons.attach_money, Colors.green),
                _buildInfoCard("Paniers vendus", "15", Icons.shopping_basket_outlined, Colors.orange),
                _buildInfoCard("Paniers restants", "8", Icons.inventory_2_outlined, Colors.blue),
                _buildInfoCard("Prix moyen", "3000 FCFA", Icons.trending_up, Colors.purple),
              ],
            ),
            const SizedBox(height: 25),

            // --- ACTIONS RAPIDES ---
            const Text("Actions rapides", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildActionButton("Ajouter un panier", Icons.add_box, true),
                const SizedBox(width: 15),
                _buildActionButton("Voir les stats", Icons.analytics_outlined, false),
              ],
            ),
            const SizedBox(height: 25),

            // --- COMMANDES RÉCENTES ---
            const Text("Commandes récentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildRecentOrder("Client #1234", "14:30", "1500 FCFA", "Récupéré", true),
            _buildRecentOrder("Client #5678", "13:15", "2000 FCFA", "Payé", false),
            
            const SizedBox(height: 20),
            
            // --- ASTUCE DU JOUR ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("💡", style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Astuce du jour", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        Text("Créez vos paniers 2h avant la fermeture pour maximiser vos ventes."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildTopTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.black54, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, bool primary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: primary ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: primary ? null : Border.all(color: Colors.orange),
        ),
        child: Column(
          children: [
            Icon(icon, color: primary ? Colors.white : Colors.orange),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: primary ? Colors.white : Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrder(String id, String time, String price, String status, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: completed ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status, style: TextStyle(color: completed ? Colors.green : Colors.orange, fontSize: 12)),
              ),
              const SizedBox(height: 5),
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}