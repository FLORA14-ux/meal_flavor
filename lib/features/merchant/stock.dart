import 'package:flutter/material.dart';
import 'ajouter.dart';

class GestionStockPage extends StatefulWidget {
  const GestionStockPage({super.key});

  @override
  State<GestionStockPage> createState() => _GestionStockPageState();
}

class _GestionStockPageState extends State<GestionStockPage> {
  // Données de test pour les paniers du commerçant
  List<Map<String, dynamic>> _paniers = [
    {
      'id': '1',
      'nom': 'Panier surprise boulangerie',
      'heureRetrait': '18h00 - 19h30',
      'disponibles': 8,
      'vendus': 7,
      'prixOriginal': 3000,
      'prixReduit': 1500,
      'actif': true,
    },
    {
      'id': '2',
      'nom': 'Viennoiseries du jour',
      'heureRetrait': '16h00 - 18h00',
      'disponibles': 5,
      'vendus': 3,
      'prixOriginal': 2000,
      'prixReduit': 1000,
      'actif': true,
    },
    {
      'id': '3',
      'nom': 'Pains et croissants',
      'heureRetrait': '14h00 - 16h00',
      'disponibles': 0,
      'vendus': 10,
      'prixOriginal': 2500,
      'prixReduit': 1200,
      'actif': false,
    },
  ];

  // Calculer les statistiques
  int get _totalActifs => _paniers.where((p) => p['actif'] == true).length;
  int get _totalDisponibles => _paniers.fold(0, (sum, p) => sum + (p['disponibles'] as int));
  int get _totalVendus => _paniers.fold(0, (sum, p) => sum + (p['vendus'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des stocks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Statistiques en haut
            _buildStatistiques(),
            
            const SizedBox(height: 24),
            
            // Titre section paniers actifs
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
            
            // Liste des paniers actifs
            ..._paniers
                .where((p) => p['actif'] == true)
                .map((panier) => _buildPanierCard(panier, true)),
            
            const SizedBox(height: 24),
            
            // Titre section paniers inactifs
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
            
            // Liste des paniers inactifs
            ..._paniers
                .where((p) => p['actif'] == false)
                .map((panier) => _buildPanierCard(panier, false)),
            
            // Astuce en bas
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
              // ✅ Bouton Ajouter
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

  Widget _buildPanierCard(Map<String, dynamic> panier, bool estActif) {
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
            // En-tête avec nom et badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    panier['nom'],
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
            
            // Heure
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  panier['heureRetrait'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Disponibles et Vendus
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
                        '${panier['disponibles']}',
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
                        '${panier['vendus']}',
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
            
            // Prix
            Row(
              children: [
                Text(
                  '${panier['prixOriginal']} FCFA',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${panier['prixReduit']} FCFA',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Boutons d'action
            if (estActif)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _desactiverPanier(panier['id']);
                      },
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
                      onPressed: () {
                        // TODO: Ouvrir formulaire de modification
                      },
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
                      onPressed: () {
                        _reactiverPanier(panier['id']);
                      },
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
                    onPressed: () {
                      _supprimerPanier(panier['id']);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            
            // Message pour paniers vendus aujourd'hui
            if (!estActif && panier['vendus'] > 0)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'Vendus aujourd\'hui',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${panier['vendus']} paniers',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
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
              'Désactivez vos paniers lorsqu\'ils sont épuisés pour éviter les déceptions. Vous pourrez les réactiver quand vous le souhaitez.',
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

  // Fonction pour désactiver un panier
  void _desactiverPanier(String id) {
    setState(() {
      final index = _paniers.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _paniers[index]['actif'] = false;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panier désactivé avec succès'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Fonction pour réactiver un panier
  void _reactiverPanier(String id) {
    setState(() {
      final index = _paniers.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _paniers[index]['actif'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panier réactivé avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Fonction pour supprimer un panier
  void _supprimerPanier(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le panier'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce panier ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _paniers.removeWhere((p) => p['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Panier supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Fonction pour ajouter un nouveau panier
  void _ajouterNouveauPanier() async {
    final nouveauPanier = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AjouterPanierPage(),
      ),
    );
    
    // Si un panier a été créé, l'ajouter à la liste
    if (nouveauPanier != null) {
      setState(() {
        _paniers.add(nouveauPanier);
      });
    }
  }
}