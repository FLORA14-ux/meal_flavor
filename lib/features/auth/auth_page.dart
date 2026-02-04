import 'package:flutter/material.dart';
import 'package:meal_flavor/core/services/auth_service.dart';
import 'package:meal_flavor/core/utils/role_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _authService = AuthService();

  bool isClient = true;
  bool _isLoading = false;

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();

  final _registerEmail = TextEditingController();
  final _registerPassword = TextEditingController();
  final _registerDisplayName = TextEditingController();
  final _registerPhoneNumber = TextEditingController();

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _registerEmail.dispose();
    _registerPassword.dispose();
    _registerDisplayName.dispose();
    _registerPhoneNumber.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _loginEmail.text.trim();
    final password = _loginPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email et mot de passe requis');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await _authService.login(email: email, password: password);
      final role = user['role']?.toString() ?? 'CLIENT';
      _goToHome(role);
    } catch (error) {
      _showMessage(error.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    final email = _registerEmail.text.trim();
    final password = _registerPassword.text.trim();
    final displayName = _registerDisplayName.text.trim();
    final phoneNumber = _registerPhoneNumber.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email et mot de passe requis');
      return;
    }

    final role = isClient ? 'CLIENT' : 'MERCHANT';

    setState(() => _isLoading = true);
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        displayName: displayName.isEmpty ? null : displayName,
        phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
        role: role,
      );
      final userRole = user['role']?.toString() ?? role;
      _goToHome(userRole);
    } catch (error) {
      _showMessage(error.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToHome(String role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => buildHomeForRole(role)),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E944B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.public, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              "Meal Flavor",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Sauvons la planète, un panier à la fois",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 30),
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
                      height: 550, // Reverted to fixed height
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

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView( // Added SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildRoleSelector(),
            const SizedBox(height: 20),
            _buildTextField("Email", Icons.email_outlined, "ex: user@mail.com", controller: _loginEmail),
            const SizedBox(height: 15),
            _buildTextField(
              "Mot de passe",
              Icons.lock_outline,
              "••••••••",
              isPassword: true,
              controller: _loginPassword,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: const Text("Mot de passe oublié ?")),
            ),
            const SizedBox(height: 10),
            _buildMainButton("Se connecter", _handleLogin),
            const SizedBox(height: 20),
            _buildDemoAccounts(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView( // Added SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Je suis :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildRoleSelector(),
            const SizedBox(height: 20),
            _buildTextField("Nom complet", Icons.person_outline, "Kofi Mensah", controller: _registerDisplayName),
            const SizedBox(height: 15),
            _buildTextField("Email", Icons.email_outlined, "ex: user@mail.com", controller: _registerEmail),
            const SizedBox(height: 15),
            _buildTextField("Téléphone", Icons.phone_outlined, "+228 90 12 34 56", controller: _registerPhoneNumber),
            const SizedBox(height: 15),
            _buildTextField(
              "Mot de passe",
              Icons.lock_outline,
              "••••••••",
              isPassword: true,
              controller: _registerPassword,
            ),
            const SizedBox(height: 30),
            _buildMainButton("S'inscrire", _handleRegister),
            const SizedBox(height: 20),
            _buildDemoAccounts(),
          ],
        ),
      ),
    );
  }

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

  Widget _buildTextField(
    String label,
    IconData icon,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
        onPressed: _isLoading ? null : onPressed,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
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
            _demoBox("Client", "client@mail.com"),
            const SizedBox(width: 10),
            _demoBox("Commerçant", "merchant@mail.com"),
          ],
        ),
      ],
    );
  }

  Widget _demoBox(String role, String value) {
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
            Text(value, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
