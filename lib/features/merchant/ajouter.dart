import 'package:flutter/material.dart';

class AjouterPanierPage extends StatefulWidget {
  const AjouterPanierPage({super.key});

  @override
  State<AjouterPanierPage> createState() => _AjouterPanierPageState();
}

class _AjouterPanierPageState extends State<AjouterPanierPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers pour les champs de texte
  final _titreController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _prixOriginalController = TextEditingController();
  final _prixReduitController = TextEditingController();
  final _heureDebutController = TextEditingController();
  final _heureFinController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Pour afficher le pourcentage de réduction
  int _reductionPourcentage = 0;
  bool _showReduction = false;

  @override
  void dispose() {
    _titreController.dispose();
    _quantiteController.dispose();
    _prixOriginalController.dispose();
    _prixReduitController.dispose();
    _heureDebutController.dispose();
    _heureFinController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Calculer le pourcentage de réduction
  void _calculerReduction() {
    final prixOriginal = double.tryParse(_prixOriginalController.text);
    final prixReduit = double.tryParse(_prixReduitController.text);

    if (prixOriginal != null && prixReduit != null && prixOriginal > 0) {
      final reduction = ((prixOriginal - prixReduit) / prixOriginal * 100).round();
      
      setState(() {
        _reductionPourcentage = reduction;
        _showReduction = true;
      });
    } else {
      setState(() {
        _showReduction = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un panier'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre du panier
              _buildSectionTitle(Icons.shopping_bag, 'Titre du panier'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  hintText: 'Ex: Panier surprise boulangerie',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Quantité disponible
              _buildSectionTitle(Icons.numbers, 'Quantité disponible'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ex: 5',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Prix original et prix réduit
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(Icons.attach_money, 'Prix original (FCFA)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _prixOriginalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '3000',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) => _calculerReduction(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requis';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Nombre invalide';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(Icons.attach_money, 'Prix réduit (FCFA)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _prixReduitController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '1500',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) => _calculerReduction(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requis';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Nombre invalide';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Affichage de la réduction
              if (_showReduction) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _reductionPourcentage < 30
                        ? Colors.red[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _reductionPourcentage < 30
                          ? Colors.red[200]!
                          : Colors.orange[200]!,
                    ),
                  ),
                  child: Text(
                    'Réduction : -$_reductionPourcentage%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _reductionPourcentage < 30
                          ? Colors.red[700]
                          : Colors.orange[700],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Créneau de collecte
              _buildSectionTitle(Icons.access_time, 'Créneau de collecte'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heureDebutController,
                      decoration: const InputDecoration(
                        hintText: '--:--',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context, _heureDebutController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requis';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heureFinController,
                      decoration: const InputDecoration(
                        hintText: '--:--',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      readOnly: true,
                      onTap: () => _selectTime(context, _heureFinController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requis';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Description (optionnelle)
              const Text(
                'Description (optionnelle)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Décrivez le contenu possible du panier...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bouton créer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _creerPanier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Créer le panier',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Information en bas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Les paniers seront automatiquement visibles par les clients dans la zone de collecte définie. Assurez-vous d\'avoir les produits disponibles avant de créer le panier.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  //  : Retourne le panier créé
  void _creerPanier() {
    if (_formKey.currentState!.validate()) {
      // Créer le nouveau panier
      final nouveauPanier = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(), // ID unique
        'nom': _titreController.text,
        'heureRetrait': '${_heureDebutController.text} - ${_heureFinController.text}',
        'disponibles': int.parse(_quantiteController.text),
        'vendus': 0,
        'prixOriginal': double.parse(_prixOriginalController.text).toInt(),
        'prixReduit': double.parse(_prixReduitController.text).toInt(),
        'actif': true,
      };
      
      // Afficher message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Panier créé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Retourner le panier créé à la page précédente
      Navigator.pop(context, nouveauPanier);
    }
  }
}