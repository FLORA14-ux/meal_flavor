import 'package:flutter/material.dart';
import 'categorie.dart';
import 'panier.dart';
import 'detail_panier.dart';

class CategoryItem {
  final String titre;
  final IconData icon;
  final String apiPath; 

  CategoryItem({
    required this.titre,
    required this.icon,
    required this.apiPath,
  });
}

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  // État : Stocke le chemin API de la catégorie sélectionnée (initialement 'all')
  String _selectedCategoryPath = 'all';

  // Tableau des catégories
  final List<CategoryItem> _categories = [
    CategoryItem(titre: 'Tous', icon: Icons.all_inclusive, apiPath: 'all'),
    CategoryItem(
      titre: 'Boulangerie',
      icon: Icons.bakery_dining,
      apiPath: 'BOULANGERIE',
    ),
    CategoryItem(titre: 'Restaurant', icon: Icons.restaurant, apiPath: 'RESTAURANT'),
    CategoryItem(titre: 'Fruits & Légumes', icon: Icons.restaurant_menu, apiPath: 'FRUITS_LEGUMES'),
    CategoryItem(titre: 'Super marché', icon: Icons.store, apiPath: 'SUPER_MARCHE'),
  ];

  // Données de test pour les paniers
  final List<Panier> _paniersTest = [
    Panier(
      id: '1',
      nom: 'Boulangerie Le Palmier',
      categorie: 'BOULANGERIE',
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
      prixOriginal: 3000,
      prixReduit: 1500,
      reduction: 50,
      contenuPanier: 'Panier surprise contenant des viennoiseries, pains du jour et pâtisseries. Produits frais de la journée.',
      heureRetrait: '18h00 - 19h30',
      adresseRetrait: 'Boulevard du 13 Janvier, Lomé',
      distance: 1.2,
      paniersDisponibles: 5,
    ),
    Panier(
      id: '2',
      nom: 'Restaurant Le Gourmet',
      categorie: 'RESTAURANT',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500',
      prixOriginal: 5000,
      prixReduit: 2500,
      reduction: 52,
      contenuPanier: 'Plat du jour avec accompagnements. Cuisine locale fraîche et savoureuse.',
      heureRetrait: '19h00 - 20h30',
      adresseRetrait: 'Avenue de la Paix, Lomé',
      distance: 0.8,
      paniersDisponibles: 3,
    ),
    Panier(
      id: '3',
      nom: 'Fruits & Légumes Bio',
      categorie: 'FRUITS_LEGUMES',
      imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=500',
      prixOriginal: 2000,
      prixReduit: 1000,
      reduction: 50,
      contenuPanier: 'Assortiment de fruits et légumes frais de saison. Bio et local.',
      heureRetrait: '17h00 - 18h00',
      adresseRetrait: 'Marché central, Lomé',
      distance: 2.1,
      paniersDisponibles: 8,
    ),
  ];

  // Fonction appelée lorsqu'on clique sur une catégorie
  void _selectCategory(String apiPath) {
    if (_selectedCategoryPath == apiPath) return;

    setState(() {
      _selectedCategoryPath = apiPath;
    });
  }

  // ✅ FONCTION AJOUTÉE : Filtrer les paniers selon la catégorie sélectionnée
  List<Panier> _getFilteredPaniers() {
    if (_selectedCategoryPath == 'all') {
      return _paniersTest; // Afficher tous les paniers
    } else {
      // Filtrer les paniers par catégorie
      return _paniersTest
          .where((panier) => panier.categorie == _selectedCategoryPath)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Flavor',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: const Icon(Icons.fastfood),
        
      ),
      body: Column(
        children: [
          // Titre principal et sous-titre
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Column(
              children: [
                const Text(
                  'Découvrez nos paniers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sauvez des repas, économisez de l\'argent',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Section de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher un commerce...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Gestion des catégories en scroll horizontal
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category.apiPath == _selectedCategoryPath;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Categorie(
                    titre: category.titre,
                    icon: category.icon,
                    isSelected: isSelected,
                    onTap: () {
                      _selectCategory(category.apiPath);
                    },
                  ),
                );
              },
            ),
          ),

          // Titre de section
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Paniers disponibles près de vous',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ✅ MODIFIÉ : Liste des paniers filtrés
          Expanded(
            child: _getFilteredPaniers().isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun panier disponible',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'dans cette catégorie',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _getFilteredPaniers().length,
                    itemBuilder: (context, index) {
                      final panier = _getFilteredPaniers()[index];
                      return _buildPanierCard(panier);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher une carte de panier
  Widget _buildPanierCard(Panier panier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigation vers la page de détails
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPanierPage(panier: panier),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badge de réduction
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    panier.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Badge de réduction
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '-${panier.reduction}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Informations du panier
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${panier.distance} km',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Nom du commerce
                  Text(
                    panier.nom,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Catégorie
                  Text(
                    panier.categorie,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Heure de retrait
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        panier.heureRetrait,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prix barré
                      Text(
                        '${panier.prixOriginal.toInt()} FCFA',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      // Prix réduit
                      Text(
                        '${panier.prixReduit.toInt()} FCFA',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Paniers restants
                  Text(
                    '${panier.paniersDisponibles} restants',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
}