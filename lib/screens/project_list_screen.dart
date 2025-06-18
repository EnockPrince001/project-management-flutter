import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';
import 'package:project_management_app/screens/project_detail_screen.dart';

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
          appBar: AppBar(title: const Text('Projects')),
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
        if (refetch != null) {
          refetch();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(project['projectName']?[0] ?? 'P',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              title: Text(project['projectName'] ?? 'No Name',
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                    'Starts: ${DateTime.parse(project['startDate']).toLocal().toString().substring(0, 10)}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectDetailScreen(project: project),
                    )).then((_) {
                  if (refetch != null) {
                    refetch();
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}
