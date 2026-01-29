import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'panier.dart'; // Vérifie que ton fichier s'appelle bien panier.dart

class ConfirmationPage extends StatefulWidget {
  final Panier panier;
  final String methodePaiement;

  const ConfirmationPage({
    super.key,
    required this.panier,
    required this.methodePaiement,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  // Contrôleur pour capturer le widget en image
  final ScreenshotController screenshotController = ScreenshotController();

  // Fonction pour télécharger le reçu
  Future<void> _telechargerRecu() async {
    try {
      // On capture uniquement le contenu du Screenshot widget
      final Uint8List? image = await screenshotController.capture();

      if (image != null) {
        // Enregistrement dans la galerie
        final result = await ImageGallerySaver.saveImage(
          image,
          name: "Recu_Antigaspi_${DateTime.now().millisecondsSinceEpoch}",
          quality: 100,
        );

        if (result != null && (result['isSuccess'] == true || result != "")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reçu enregistré dans la galerie !"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Échec du téléchargement. Vérifiez les permissions."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String codeUnique = "ANTIGASPI-${DateTime.now().millisecondsSinceEpoch}";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Confirmation"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- DEBUT DE LA ZONE CAPTURABLE ---
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.grey[50], // Important pour le fond de l'image
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Réservation confirmée !",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text("Votre panier est prêt à être retiré"),

                    // Carte du QR Code
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: codeUnique,
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Présentez ce QR code au commerçant",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "Code: $codeUnique",
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Détails de la commande
                    _buildSection(
                      "Détails de la commande",
                      [
                        _row("Commerce", widget.panier.nom),
                        _row("Date", "29/01/2026 06:40"),
                        _row("Paiement", widget.methodePaiement),
                        _row("Statut", "Payé", valColor: Colors.green),
                        const Divider(),
                        _row("Total payé", "${widget.panier.prixReduit.toInt()} FCFA", isBold: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // --- FIN DE LA ZONE CAPTURABLE ---

            // Informations de retrait (Hors zone capture pour rester propre)
            _buildSection(
              "Informations de retrait",
              [
                _rowIcon(Icons.access_time, "Heure de retrait", widget.panier.heureRetrait),
                const SizedBox(height: 10),
                _rowIcon(Icons.location_on, "Adresse", widget.panier.adresseRetrait),
              ],
              bgColor: Colors.green[50],
            ),

            // Boutons d'action
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: _telechargerRecu,
                    icon: const Icon(Icons.download),
                    label: const Text("Télécharger le reçu"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    icon: const Icon(Icons.home),
                    label: const Text("Retour à l'accueil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
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

  // Helpers widgets
  Widget _buildSection(String title, List<Widget> items, {Color? bgColor}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _row(String label, String val, {bool isBold = false, Color? valColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: valColor)),
        ],
      ),
    );
  }

  Widget _rowIcon(IconData icon, String label, String val) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text(val, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            ],
          ),
        ),
      ],
    );
  }
}