import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';
import 'package:project_management_app/providers/auth_provider.dart';
// import 'package:project_management_app/screens/login_screen.dart'; // No longer needed for explicit navigation
import 'package:project_management_app/screens/project_detail_screen.dart';
import 'package:provider/provider.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getProjectsQuery),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('All Projects'),
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                tooltip: 'Exit Guest Mode',
                onPressed: () {
                  // This is the ONLY line needed for logout.
                  // The AuthWrapper (which is the home of your MaterialApp)
                  // will automatically react to the AuthProvider's state change
                  // (isLoggedIn and isGuestMode becoming false) and display the LoginScreen.
                  Provider.of<AuthProvider>(context, listen: false).logout();
                },
              ),
            ],
          ),
          body: _buildBody(context, result, refetch),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final created =
                  await Navigator.pushNamed(context, '/create-project');
              if (created == true && refetch != null) {
                refetch();
              }
            },
            tooltip: 'Add Project',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, QueryResult result, VoidCallback? refetch) {
    if (result.hasException) {
      return Center(child: Text(result.exception.toString()));
    }
    if (result.isLoading && result.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    List? projects = result.data?['projects'];
    if (projects == null || projects.isEmpty) {
      return const Center(child: Text('No projects found.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (refetch != null) refetch();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            child: ListTile(
              title: Text(project['projectName'] ?? 'No Name'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailScreen(project: project))).then((_) {
                  if (refetch != null) refetch();
                });
              },
            ),
          );
        },
      ),
    );
  }
}
