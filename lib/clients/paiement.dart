import 'package:flutter/material.dart';
import 'panier.dart'; // Import de ton modèle
import 'package:meal_flavor/clients/confirmation.dart'; // Import de la page QR Code

class PaiementPage extends StatelessWidget {
  final Panier panier; // On utilise l'objet complet au lieu de simples variables

  const PaiementPage({
    super.key, 
    required this.panier,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Retour"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Paiement", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            
            // Résumé de la commande (Card grise)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft, 
                    child: Text(
                      "Résumé de la commande", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    )
                  ),
                  const SizedBox(height: 15),
                  _rowDetail(panier.nom, "${panier.prixReduit.toInt()} FCFA"),
                  _rowDetail("Heure de retrait", panier.heureRetrait),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(),
                  ),
                  _rowDetail("Total", "${panier.prixReduit.toInt()} FCFA", isTotal: true),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            const Text(
              "Mode de paiement", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            const SizedBox(height: 15),
            
            // Liste des modes de paiement
            _methodTile(context, "Flooz", "Paiement mobile", Colors.orange, Icons.phone_android),
            _methodTile(context, "TMoney", "Paiement mobile", Colors.red, Icons.phone_android),
            _methodTile(context, "Espèces", "Payer au retrait", Colors.blueGrey, Icons.payments),
            
            const Spacer(),
            
            // Note informative bleue
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[800], size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Vous recevrez un QR code de confirmation après le paiement. Présentez-le au commerçant lors du retrait.",
                      style: TextStyle(color: Colors.blue[900], fontSize: 13),
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

  // Widget pour les lignes du résumé
  Widget _rowDetail(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.black : Colors.grey[600], fontSize: isTotal ? 16 : 14)),
          Text(value, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : Colors.black,
            fontSize: isTotal ? 18 : 14,
          )),
        ],
      ),
    );
  }

  // Widget pour les tuiles de paiement
  Widget _methodTile(BuildContext context, String title, String subtitle, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color, 
            borderRadius: BorderRadius.circular(8)
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _confirmerPaiement(context, title),
      ),
    );
  }

  // Boîte de dialogue de confirmation finale
  void _confirmerPaiement(BuildContext context, String methode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Confirmer la réservation"),
        content: Text("Voulez-vous finaliser votre commande de ${panier.prixReduit.toInt()} FCFA via $methode ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context); // Fermer le dialogue
              // Navigation vers la page de succès avec le QR Code
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmationPage(
                    panier: panier, 
                    methodePaiement: methode,
                  ),
                ),
              );
            },
            child: const Text("Confirmer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}