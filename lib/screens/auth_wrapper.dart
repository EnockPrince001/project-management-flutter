import 'package:flutter/material.dart';
import 'package:project_management_app/providers/auth_provider.dart';
import 'package:project_management_app/screens/login_screen.dart';
import 'package:project_management_app/screens/main_tabs_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Show MainTabsScreen if logged in or if in guest mode
    if (authProvider.isLoggedIn || authProvider.isGuestMode) {
      return const MainTabsScreen();
    } else {
      // Otherwise, show the LoginScreen
      return const LoginScreen();
    }
  }
}
