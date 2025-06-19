import 'package:flutter/material.dart';
import 'package:project_management_app/providers/auth_provider.dart';
import 'package:project_management_app/screens/dashboard_screen.dart';
import 'package:project_management_app/screens/my_projects_screen.dart';
import 'package:project_management_app/screens/project_list_screen.dart';
import 'package:project_management_app/screens/user_list_screen.dart';
import 'package:provider/provider.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});
  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _screens = authProvider.isLoggedIn
        ? [
            const MyProjectsScreen(),
            const UserListPage(),
            const DashboardScreen()
          ]
        : [
            const ProjectListPage(),
            const UserListPage(),
            const DashboardScreen()
          ];
    _navItems = authProvider.isLoggedIn
        ? [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_pin_circle), label: 'My Projects'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined), label: 'Users'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: 'Dashboard')
          ]
        : [
            const BottomNavigationBarItem(
                icon: Icon(Icons.folder_shared_outlined),
                label: 'All Projects'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined), label: 'Users'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: 'Dashboard')
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
