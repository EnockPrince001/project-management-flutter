// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';
import 'package:project_management_app/widgets/stat_card.dart';
import 'package:project_management_app/widgets/task_pie_chart.dart';
import 'package:project_management_app/providers/auth_provider.dart'; // Import AuthProvider
import 'package:provider/provider.dart'; // Import Provider

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed the conditional logic for queryDocument as getGuestDashboardStatsQuery is not defined.
    // Dashboard will now always use getDashboardStatsQuery.
    // If you need specific guest data, you'll need to define that GraphQL query in graphql_queries.dart
    // and potentially implement different logic in your backend for it.

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Query(
        options: QueryOptions(
            document: gql(
                getDashboardStatsQuery)), // Always use getDashboardStatsQuery
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.isLoading && result.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(
                child: Text(
                    "Error: ${result.exception.toString()}")); // Convert exception to string
          }

          // Ensure data exists before accessing
          final List projects = result.data?['projects'] ?? [];
          final List tasks = result.data?['tasks'] ?? [];
          final List users = result.data?['users'] ?? [];

          // The problem you highlighted last time was related to the GraphQL query not returning
          // 'tasks' or 'status' in a way that the 'completedTasks' and 'statusCounts'
          // could easily consume. Assuming tasks list contains maps like {'status': 'Completed'}.
          final completedTasks = tasks
              .where(
                  (t) => (t as Map<String, dynamic>)['status'] == 'Completed')
              .length;

          // Explicitly cast 'element' inside the fold callback for safety and type correctness.
          final statusCounts =
              tasks.fold<Map<String, int>>(<String, int>{}, (map, element) {
            final task = element as Map<String, dynamic>; // Explicit cast here
            final status = task['status'] as String?; // Cast status to String?
            if (status != null) {
              map[status] = (map[status] ?? 0) + 1;
            }
            return map;
          });

          return RefreshIndicator(
            onRefresh: () async => refetch?.call(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                        title: 'Total Projects',
                        value: projects.length.toString(),
                        icon: Icons.folder_copy_outlined,
                        color: Colors.blue.shade300),
                    StatCard(
                        title: 'Total Tasks',
                        value: tasks.length.toString(),
                        icon: Icons.list_alt,
                        color: Colors.orange.shade300),
                    StatCard(
                        title: 'Completed',
                        value: completedTasks.toString(),
                        icon: Icons.check_circle_outline,
                        color: Colors.green.shade400),
                    StatCard(
                        title: 'Total Users',
                        value: users.length.toString(),
                        icon: Icons.people_outline,
                        color: Colors.purple.shade300),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Tasks by Status',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                SizedBox(
                    height: 250,
                    // Pass statusCounts only if it has data, otherwise empty map
                    child: TaskPieChart(
                        statusCounts:
                            statusCounts.isNotEmpty ? statusCounts : {})),
              ],
            ),
          );
        },
      ),
    );
  }
}
