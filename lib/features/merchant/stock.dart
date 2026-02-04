import 'package:flutter/material.dart';
import 'package:meal_flavor/features/merchant/ajouter.dart';
import 'package:meal_flavor/features/merchant/merchant_basket.dart';
import 'package:meal_flavor/features/merchant/merchant_basket_service.dart';
import 'package:meal_flavor/features/merchant/merchant_service.dart';

class GestionStockPage extends StatefulWidget {
  const GestionStockPage({super.key});

  @override
  State<GestionStockPage> createState() => _GestionStockPageState();
}

class _GestionStockPageState extends State<GestionStockPage> {
  final _merchantService = MerchantService();
  final _basketService = MerchantBasketService();

  bool _isLoading = false;
  String? _errorMessage;
  List<MerchantBasket> _baskets = [];
  String? _merchantId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final merchant = await _merchantService.getMyMerchant();
      final merchantId = merchant['id']?.toString();
      if (merchantId == null || merchantId.isEmpty) {
        throw Exception('Profil commerçant introuvable');
      }

      final baskets = await _basketService.fetchMyBaskets(merchantId: merchantId);
      if (!mounted) return;
      setState(() {
        _merchantId = merchantId;
        _baskets = baskets;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<MerchantBasket> get _activeBaskets =>
      _baskets.where((b) => b.status == 'AVAILABLE').toList();

  List<MerchantBasket> get _inactiveBaskets =>
      _baskets.where((b) => b.status != 'AVAILABLE').toList();

  int get _totalActifs => _activeBaskets.length;
  int get _totalDisponibles =>
      _baskets.fold(0, (sum, b) => sum + b.availableQuantity);
  int get _totalVendus => _baskets.fold(0, (sum, b) => sum + b.sold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des stocks'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildStatistiques(),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Paniers actifs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_activeBaskets.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Aucun panier actif'),
                        )
                      else
                        ..._activeBaskets.map((panier) => _buildPanierCard(panier, true)),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Paniers inactifs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_inactiveBaskets.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Aucun panier inactif'),
                        )
                      else
                        ..._inactiveBaskets.map((panier) => _buildPanierCard(panier, false)),
                      _buildAstuce(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatistiques() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestion des stocks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _ajouterNouveauPanier,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text(
                  'Ajouter',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                value: '$_totalActifs',
                label: 'Actifs',
                color: Colors.green,
              ),
              _buildStatItem(
                value: '$_totalDisponibles',
                label: 'Disponibles',
                color: Colors.blue,
              ),
              _buildStatItem(
                value: '$_totalVendus',
                label: 'Vendus',
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPanierCard(MerchantBasket panier, bool estActif) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    panier.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: estActif ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    estActif ? 'Actif' : 'Inactif',
                    style: TextStyle(
                      color: estActif ? Colors.green[700] : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  panier.pickupWindow,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disponibles',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${panier.availableQuantity}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendus',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${panier.sold}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '${panier.originalPrice.toInt()} FCFA',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${panier.discountedPrice.toInt()} FCFA',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (estActif)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _desactiverPanier(panier),
                      icon: Icon(Icons.block, size: 18, color: Colors.orange[700]),
                      label: Text(
                        'Désactiver',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.orange[700]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                      label: const Text(
                        'Modifier',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _reactiverPanier(panier),
                      icon: const Icon(Icons.visibility, size: 18, color: Colors.white),
                      label: const Text(
                        'Réactiver',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _supprimerPanier(panier),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstuce() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Désactivez vos paniers lorsqu\'ils sont épuisés pour éviter les déceptions.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _desactiverPanier(MerchantBasket panier) async {
    try {
      final updated = await _basketService.updateStatus(id: panier.id, status: 'SOLD_OUT');
      setState(() {
        _baskets = _baskets.map((b) => b.id == updated.id ? updated : b).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Panier désactivé avec succès'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Future<void> _reactiverPanier(MerchantBasket panier) async {
    try {
      final updated = await _basketService.updateStatus(id: panier.id, status: 'AVAILABLE');
      setState(() {
        _baskets = _baskets.map((b) => b.id == updated.id ? updated : b).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Panier réactivé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Future<void> _supprimerPanier(MerchantBasket panier) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le panier'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce panier ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _basketService.deleteBasket(panier.id);
      setState(() {
        _baskets.removeWhere((b) => b.id == panier.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Panier supprimé'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Future<void> _ajouterNouveauPanier() async {
    final basket = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AjouterPanierPage(),
      ),
    );

    if (basket is MerchantBasket) {
      setState(() {
        _baskets = [basket, ..._baskets];
      });
    } else if (_merchantId != null) {
      await _loadData();
    }
  }
}
