import 'package:flutter/material.dart';
import 'package:meal_flavor/core/services/auth_service.dart';
import 'package:meal_flavor/features/merchant/merchant_service.dart';
import 'package:meal_flavor/features/auth/auth_page.dart';

class DashboardCommercant extends StatefulWidget {
  const DashboardCommercant({super.key});

  @override
  State<DashboardCommercant> createState() => _DashboardCommercantState();
}

class _DashboardCommercantState extends State<DashboardCommercant> {
  final _merchantService = MerchantService();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _merchant;

  @override
  void initState() {
    super.initState();
    _loadMerchant();
  }

  Future<void> _loadMerchant() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final merchant = await _merchantService.getMyMerchant();
      if (!mounted) return;
      setState(() {
        _merchant = merchant;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color orangeMeal = Color(0xFFFF9800);
    const Color greenSuccess = Color(0xFFE8F5E9);
    const Color textGrey = Color(0xFF757575);

    final merchantName = _merchant?['businessName']?.toString() ?? 'Votre commerce';
    final merchantPhone = _merchant?['phoneNumber']?.toString() ?? '-';
    final merchantAddress = _merchant?['address']?.toString() ?? '-';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  onPressed: _logout,
                  child: const Text("Déconnexion", style: TextStyle(color: Colors.redAccent)),
                )
              ],
            ),
            const SizedBox(height: 25),

            const Text("Tableau de bord", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LinearProgressIndicator(),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                    const SizedBox(height: 8),
                    TextButton(onPressed: _loadMerchant, child: const Text('Réessayer')),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(merchantName, style: const TextStyle(fontSize: 16, color: textGrey)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: textGrey),
                      Text(" $merchantPhone  ", style: const TextStyle(color: textGrey)),
                      const Icon(Icons.location_on, size: 14, color: textGrey),
                      Text(" $merchantAddress", style: const TextStyle(color: textGrey)),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: orangeMeal),
                  const SizedBox(width: 10),
                  const Text("Aujourd'hui", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(_todayLabel()),
                ],
              ),
            ),
            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3,
              children: [
                _buildInfoCard("Ventes du jour", "0 FCFA", Icons.attach_money, Colors.green),
                _buildInfoCard("Paniers vendus", "0", Icons.shopping_basket_outlined, Colors.orange),
                _buildInfoCard("Paniers restants", "0", Icons.inventory_2_outlined, Colors.blue),
                _buildInfoCard("Prix moyen", "0 FCFA", Icons.trending_up, Colors.purple),
              ],
            ),
            const SizedBox(height: 25),

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

            const Text("Commandes récentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildRecentOrder("Client #1234", "14:30", "1500 FCFA", "Récupéré", true),
            _buildRecentOrder("Client #5678", "13:15", "2000 FCFA", "Payé", false),

            const SizedBox(height: 20),

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

  String _todayLabel() {
    final now = DateTime.now();
    final weekdays = [
      'lundi',
      'mardi',
      'mercredi',
      'jeudi',
      'vendredi',
      'samedi',
      'dimanche',
    ];
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday ${now.day} $month';
  }

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
