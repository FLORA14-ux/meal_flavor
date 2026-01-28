import 'package:flutter/material.dart';
import 'package:meal_flavor/clients/mainNavigation.dart';
import 'package:meal_flavor/consommateurs/navbarCommerçant.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isClient = true; // Gère la sélection Client/Commerçant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E944B), // Vert du fond
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Logo et Titre
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.public, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              "Anti-Gaspi Togo",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Sauvons la planète, un panier à la fois",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 30),

            // Carte Blanche
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF2E944B),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF2E944B),
                      tabs: [
                        Tab(text: "Connexion"),
                        Tab(text: "Inscription"),
                      ],
                    ),
                    SizedBox(
                      height: 550, // Ajuste selon tes besoins
                      child: TabBarView(
                        children: [
                          _buildLoginForm(),
                          _buildRegisterForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "En continuant, vous acceptez nos\nConditions d'utilisation et Politique de confidentialité",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- FORMULAIRE DE CONNEXION ---
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildRoleSelector(),
          const SizedBox(height: 20),
          _buildTextField("Téléphone", Icons.phone_outlined, "+228 90 12 34 56"),
          const SizedBox(height: 15),
          _buildTextField("Mot de passe", Icons.lock_outline, "••••••••", isPassword: true),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () {}, child: const Text("Mot de passe oublié ?")),
          ),
          const SizedBox(height: 10),
         _buildMainButton("Se connecter", () {
  // On vérifie quel rôle est sélectionné via la variable isClient
  if (isClient) {
    // Redirection vers l'espace Client
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()), 
    );
  } else {
    // Redirection vers l'espace Commerçant
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationCommercant()),
    );
  }
}),
          const SizedBox(height: 20),
          _buildDemoAccounts(),
        ],
      ),
    );
  }

  // --- FORMULAIRE D'INSCRIPTION ---
  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildRoleSelector(),
          const SizedBox(height: 20),
          _buildTextField("Nom complet", Icons.person_outline, "Kofi Mensah"),
          const SizedBox(height: 15),
          _buildTextField("Téléphone", Icons.phone_outlined, "+228 90 12 34 56"),
          const SizedBox(height: 15),
          _buildTextField("Mot de passe", Icons.lock_outline, "••••••••", isPassword: true),
          const SizedBox(height: 30),
          _buildMainButton("S'inscrire", () {
  // Même logique : on redirige selon le rôle choisi lors de l'inscription
  if (isClient) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationCommercant()),
    );
  }
}),
          const SizedBox(height: 20),
          _buildDemoAccounts(),
        ],
      ),
    );
  }

  // --- WIDGETS RÉUTILISABLES ---

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _roleCard("Client", Icons.shopping_bag_outlined, isClient, () => setState(() => isClient = true)),
        const SizedBox(width: 10),
        _roleCard("Commerçant", Icons.storefront_outlined, !isClient, () => setState(() => isClient = false)),
      ],
    );
  }

  Widget _roleCard(String label, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? const Color(0xFF2E944B) : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(15),
            color: selected ? const Color(0xFFE8F5E9) : Colors.white,
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? const Color(0xFF2E944B) : Colors.grey),
              Text(label, style: TextStyle(color: selected ? const Color(0xFF2E944B) : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            suffixIcon: isPassword ? const Icon(Icons.visibility_outlined) : null,
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E944B),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildDemoAccounts() {
    return Column(
      children: [
        const Text("Comptes de démonstration :", style: TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          children: [
            _demoBox("👤 Client", "+228 90 12 34 56"),
            const SizedBox(width: 10),
            _demoBox("🏪 Commerçant", "+228 91 23 45 67"),
          ],
        ),
      ],
    );
  }

  Widget _demoBox(String role, String phone) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(role, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            Text(phone, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}