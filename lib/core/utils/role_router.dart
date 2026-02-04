import 'package:flutter/material.dart';
import 'package:meal_flavor/features/client/main_navigation.dart';
import 'package:meal_flavor/features/merchant/navbar_commercant.dart';

Widget buildHomeForRole(String role) {
  switch (role) {
    case 'CLIENT':
      return const MainNavigation();
    case 'MERCHANT':
    case 'ADMIN':
      return const MainNavigationCommercant();
    default:
      return const MainNavigation();
  }
}
