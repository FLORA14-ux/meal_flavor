import 'package:flutter/material.dart';
import 'package:meal_flavor/core/services/auth_service.dart';
import 'package:meal_flavor/core/utils/role_router.dart';
import 'package:meal_flavor/features/auth/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = await _authService.me();
      if (!mounted) return;

      if (user == null) {
        _goToAuth();
        return;
      }

      final role = user['role']?.toString() ?? 'CLIENT';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => buildHomeForRole(role)),
      );
    } catch (_) {
      if (!mounted) return;
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 21, 119, 21),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_rounded, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "MealFlavor",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
