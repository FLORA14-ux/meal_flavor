import 'package:flutter/material.dart';
import 'package:meal_flavor/features/merchant/merchant_basket_service.dart';

class AjouterPanierPage extends StatefulWidget {
  const AjouterPanierPage({super.key});

  @override
  State<AjouterPanierPage> createState() => _AjouterPanierPageState();
}

class _AjouterPanierPageState extends State<AjouterPanierPage> {
  final _formKey = GlobalKey<FormState>();
  final _basketService = MerchantBasketService();

  final _titreController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _prixOriginalController = TextEditingController();
  final _prixReduitController = TextEditingController();
  final _heureDebutController = TextEditingController();
  final _heureFinController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'SWEET';
  int _reductionPourcentage = 0;
  bool _showReduction = false;
  bool _isLoading = false;

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
              _buildSectionTitle(Icons.category_outlined, 'Catégorie'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'SWEET', child: Text('Sucré')),
                  DropdownMenuItem(value: 'SAVORY', child: Text('Salé')),
                  DropdownMenuItem(value: 'MIXED', child: Text('Mixte')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedCategory = value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

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
                          onChanged: (_) => _calculerReduction(),
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
                          onChanged: (_) => _calculerReduction(),
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
              if (_showReduction) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _reductionPourcentage < 30 ? Colors.red[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _reductionPourcentage < 30 ? Colors.red[200]! : Colors.orange[200]!,
                    ),
                  ),
                  child: Text(
                    'Réduction : -$_reductionPourcentage%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _reductionPourcentage < 30 ? Colors.red[700] : Colors.orange[700],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

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
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
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
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _creerPanier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
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
                        'Les paniers seront automatiquement visibles par les clients dans la zone de collecte définie.',
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
        final hh = picked.hour.toString().padLeft(2, '0');
        final mm = picked.minute.toString().padLeft(2, '0');
        controller.text = '$hh:$mm';
      });
    }
  }

  Future<void> _creerPanier() async {
    if (!_formKey.currentState!.validate()) return;

    final prixOriginal = double.tryParse(_prixOriginalController.text) ?? 0;
    final prixReduit = double.tryParse(_prixReduitController.text) ?? 0;
    final quantite = int.tryParse(_quantiteController.text) ?? 0;

    final start = _toDateTime(_heureDebutController.text);
    final end = _toDateTime(_heureFinController.text);

    if (start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un créneau valide')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final basket = await _basketService.createBasket(
        title: _titreController.text.trim(),
        category: _selectedCategory,
        originalPrice: prixOriginal,
        discountedPrice: prixReduit,
        quantity: quantite,
        pickupStart: start,
        pickupEnd: end,
        // description: _descriptionController.text.trim().isEmpty // Temporarily removed to isolate 400 error
        //     ? null
        //     : _descriptionController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Panier créé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, basket);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  DateTime? _toDateTime(String timeLabel) {
    final parts = timeLabel.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute).toUtc();
  }
}
