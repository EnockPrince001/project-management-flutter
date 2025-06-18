// File: lib/main.dart (REPLACE)
// This file now uses initialRoute and routes to define navigation.
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_client.dart';
import 'package:project_management_app/screens/main_tabs_screen.dart'; // Import main tabs screen
import 'package:project_management_app/theme/app_theme.dart';
import 'package:project_management_app/screens/create_project_screen.dart'; // Import CreateProjectScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  final client = getGraphQLClient();
  runApp(ProjectManagementApp(client: client));
}

class ProjectManagementApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const ProjectManagementApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Project Manager',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        // FIX: Use initialRoute and routes instead of home to enable named routes
        initialRoute: '/',
        routes: {
          '/': (context) =>
              const MainTabsScreen(), // Main tabs screen is the root
          '/create-project': (context) =>
              const CreateProjectScreen(), // This route is now properly defined
        },
      ),
    );
  }
}
