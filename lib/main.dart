import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_client.dart';
import 'package:project_management_app/screens/auth_wrapper.dart';
import 'package:project_management_app/screens/create_project_screen.dart';
import 'package:project_management_app/theme/app_theme.dart';
import 'package:project_management_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await initHiveForFlutter();
  final client = getGraphQLClient();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: ProjectManagementApp(client: client),
    ),
  );
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
        home: const AuthWrapper(),
        routes: {
          '/create-project': (context) => const CreateProjectScreen(),
        },
      ),
    );
  }
}
