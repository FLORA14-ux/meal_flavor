import 'package:flutter/material.dart';

class AjouterPanierPage extends StatefulWidget {
  const AjouterPanierPage({super.key});

  @override
  State<AjouterPanierPage> createState() => _AjouterPanierPageState();
}

class _AjouterPanierPageState extends State<AjouterPanierPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _prixOriginalController = TextEditingController(text: '3000');
  final TextEditingController _prixReduitController = TextEditingController(text: '1500');
  final TextEditingController _descriptionController = TextEditingController();
  
  String _creneauSelectionne = '';
  final List<String> _creneaux = [
    '17h00 - 18h00',
    '18h00 - 19h00',
    '19h00 - 20h00',
    '20h00 - 21h00',
    '21h00 - 22h00',
  ];

  @override
  void initState() {
    super.initState();
    if (_creneaux.isNotEmpty) {
      _creneauSelectionne = _creneaux[1]; // Valeur par défaut
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _quantiteController.dispose();
    _prixOriginalController.dispose();
    _prixReduitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _creerPanier() {
    if (_formKey.currentState!.validate()) {
      // Logique pour créer le panier
      print('Panier créé avec succès!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Panier créé avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
      // Retourner en arrière après un délai
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mode Commerçant'),
        centerTitle: true,
        actions: [
          // Badge Démo
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Démo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          // Bouton Déconnexion
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre principal
              const Text(
                'Ajouter un panier',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Champ : Titre du panier
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(
                  labelText: 'Titre du panier',
                  hintText: 'Ex: Panier surprise boulangerie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre pour le panier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ : Quantité disponible
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantité disponible',
                  hintText: 'Ex: 5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la quantité disponible';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Section Prix
              const Text(
                'Prix',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  // Prix original
                  Expanded(
                    child: TextFormField(
                      controller: _prixOriginalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Prix original (FCFA)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.money),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un prix';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Prix invalide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Prix réduit
                  Expanded(
                    child: TextFormField(
                      controller: _prixReduitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Prix réduit (FCFA)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.price_check),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un prix';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Prix invalide';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              // Afficher la réduction en pourcentage
              if (_prixOriginalController.text.isNotEmpty && 
                  _prixReduitController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Réduction: ${_calculerReduction()}%',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
              const SizedBox(height: 20),

              // Champ : Créneau de collecte
              const Text(
                'Créneau de collecte',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              DropdownButtonFormField<String>(
                value: _creneauSelectionne,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.access_time),
                ),
                items: _creneaux.map((String creneau) {
                  return DropdownMenuItem<String>(
                    value: creneau,
                    child: Text(creneau),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _creneauSelectionne = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un créneau';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),

              // Champ : Description
              const Text(
                'Description (optionnelle)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Décrivez le contenu possible du panier...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Ex: Pain, viennoiseries, pâtisseries de la journée...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 30),

              // Bouton Créer le panier
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _creerPanier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Créer le panier',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les paniers seront automatiquement visibles par les clients dans la zone de collecte définie. Assurez-vous d\'avoir les produits disponibles avant de créer le panier.',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _calculerReduction() {
    try {
      double prixOriginal = double.parse(_prixOriginalController.text);
      double prixReduit = double.parse(_prixReduitController.text);
      
      if (prixOriginal <= 0) return '0';
      
      double reduction = ((prixOriginal - prixReduit) / prixOriginal) * 100;
      return reduction.toStringAsFixed(0);
    } catch (e) {
      return '0';
    }
  }
}