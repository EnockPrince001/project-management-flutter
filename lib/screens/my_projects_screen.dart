import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';
import 'package:project_management_app/providers/auth_provider.dart';
import 'package:project_management_app/screens/project_detail_screen.dart';
import 'package:provider/provider.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.userId;

    if (userId == null) return const Center(child: Text("Not logged in."));

    return Query(
      options: QueryOptions(
        document: gql(getProjectsByUserIdQuery),
        variables: {'userId': userId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result, {refetch, fetchMore}) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Projects'),
            actions: [
              IconButton(
                  onPressed: () => authProvider.logout(),
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout'),
            ],
          ),
          body: _buildBody(context, result, refetch),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // CORRECTED: This now works identically to the "All Projects" screen.
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
    List? projects = result.data?['projectsByUserId'];
    if (projects == null || projects.isEmpty) {
      return const Center(child: Text('You have no projects. Create one!'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (refetch != null) refetch();
      },
      child: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            child: ListTile(
              title: Text(project['projectName'] ?? 'No Name'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectDetailScreen(project: project),
                  )).then((_) => refetch?.call()),
            ),
          );
        },
      ),
    );
  }
}
