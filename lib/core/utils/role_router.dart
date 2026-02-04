import 'package:flutter/material.dart';
import 'package:meal_flavor/features/client/main_navigation.dart';
import 'package:meal_flavor/features/merchant/navbar_commercant.dart';
import 'package:meal_flavor/features/merchant/merchant_home_wrapper.dart'; // Import the new wrapper

Widget buildHomeForRole(String role) {
  switch (role) {
    case 'CLIENT':
      return const MainNavigation();
    case 'MERCHANT':
      return const MerchantHomeWrapper(); // Use the new wrapper for MERCHANT role
    case 'ADMIN':
      return const MainNavigationCommercant();
    default:
      return const MainNavigation();
  }
}
