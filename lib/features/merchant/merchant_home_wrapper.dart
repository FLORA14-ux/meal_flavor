import 'package:flutter/material.dart';
import 'package:meal_flavor/features/merchant/merchant_service.dart';
import 'package:meal_flavor/features/merchant/navbar_commercant.dart';
import 'package:meal_flavor/features/merchant/merchant_profile_creation_page.dart';

class MerchantHomeWrapper extends StatefulWidget {
  const MerchantHomeWrapper({super.key});

  @override
  State<MerchantHomeWrapper> createState() => _MerchantHomeWrapperState();
}

class _MerchantHomeWrapperState extends State<MerchantHomeWrapper> {
  final MerchantService _merchantService = MerchantService();
  bool _isLoading = true;
  bool _hasMerchantProfile = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkMerchantProfile();
  }

  Future<void> _checkMerchantProfile() async {
    try {
      await _merchantService.getMyMerchant();
      setState(() {
        _hasMerchantProfile = true;
      });
    } catch (e) {
      if (e.toString().contains('404') || e.toString().contains('Merchant not found')) {
        setState(() {
          _hasMerchantProfile = false;
        });
      } else {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToProfileCreation() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MerchantProfileCreationPage(),
      ),
    );

    if (result == true) {
      // Profile created successfully, re-check merchant profile
      _isLoading = true; // Set loading to true to show indicator
      _checkMerchantProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $_errorMessage'),
              ElevatedButton(
                onPressed: _checkMerchantProfile,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasMerchantProfile) {
      // If no merchant profile, immediately navigate to creation page
      // Use WidgetsBinding.instance.addPostFrameCallback to avoid `setState` during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToProfileCreation();
      });
      // Return a placeholder while navigation happens
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const MainNavigationCommercant();
  }
}
