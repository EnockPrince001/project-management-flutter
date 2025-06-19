import 'package:flutter/material.dart';
import 'package:project_management_app/providers/auth_provider.dart';
// ignore: unused_import
import 'package:project_management_app/screens/main_tabs_screen.dart'; // Keep import, AuthWrapper handles direct routing
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Listen: false is correct here as this widget is just calling methods, not reacting to AuthProvider's state for its own rebuild.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assessment, size: 100, color: Colors.white70),
            const SizedBox(height: 20),
            Text(
              "Project Manager",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _userIdController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter Your User ID to Login',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final id = int.tryParse(_userIdController.text);
                if (id != null) {
                  authProvider.login(
                      id); // This will trigger AuthWrapper to show MainTabsScreen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Please enter a valid number for User ID.")));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  // Call the new method to enter guest mode.
                  // The AuthWrapper will react and automatically navigate to MainTabsScreen.
                  authProvider.enterGuestMode();
                },
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.8)),
                )),
          ],
        ),
      ),
    );
  }
}
