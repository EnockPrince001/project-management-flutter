// File: lib/screens/project_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';
import 'package:project_management_app/screens/create_task_screen.dart';
import 'package:project_management_app/screens/task_detail_screen.dart'; // Ensure this is correctly imported

// Extension to format DateTime for display
extension DateOnlyCompare on DateTime {
  String toShortDateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

class ProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> project; // The selected project object

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  VoidCallback? _tasksRefetch; // To hold the refetch function for tasks

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int projectId = widget.project['projectID'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project['projectName'] ?? 'Project Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Project Details Section (Enhanced Card) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.primaryColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project['projectName'] ?? 'N/A',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.project['description'] ??
                          'No description provided.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Divider(color: theme.dividerColor),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Date:',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          DateTime.parse(widget.project['startDate'])
                              .toLocal()
                              .toShortDateString(),
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (widget.project['endDate'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'End Date:',
                            style: theme.textTheme.bodyLarge,
                          ),
                          Text(
                            DateTime.parse(widget.project['endDate'])
                                .toLocal()
                                .toShortDateString(),
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Created By:',
                          style: theme.textTheme.bodyLarge,
                        ),
                        // Note: For 'createdBy', you might want to fetch and display the user's name
                        // Currently displays User ID.
                        Text(
                          'User ID: ${widget.project['createdBy']}',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // --- Tasks Section Header ---
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Tasks',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          // --- Tasks List (using Query and ListView.builder) ---
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql(getTasksByProjectIdQuery),
                variables: {'projectId': projectId},
                fetchPolicy: FetchPolicy.cacheAndNetwork,
              ),
              builder: (QueryResult result, {refetch, fetchMore}) {
                // Capture the refetch callback after the frame is built
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _tasksRefetch = refetch; // Capture the refetch callback
                  }
                });

                if (result.hasException) {
                  return Center(
                    child: Text(
                        'Error loading tasks: ${result.exception.toString()}'),
                  );
                }
                if (result.isLoading && result.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                List? tasks = result.data?['tasksByProjectId'];
                if (tasks == null || tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks for this project yet.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.task_alt, // Changed to a more general task icon
                          color: task['status'] == 'Done'
                              ? Colors.green // Use 'Done' as per task status
                              : theme.colorScheme.secondary,
                        ),
                        title: Text(
                          task['taskName'] ?? 'No Task Name',
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${task['status'] ?? 'N/A'}'),
                            Text('Priority: ${task['priority'] ?? 'N/A'}'),
                            if (task['dueDate'] != null)
                              Text(
                                  'Due: ${DateTime.parse(task['dueDate']).toLocal().toShortDateString()}'),
                            Text(
                                'Assigned To: ${task['assignedTo'] ?? 'N/A'}'), // Display assignedTo
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 14, color: theme.iconTheme.color),
                        onTap: () {
                          // Navigate to task details screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskDetailScreen(task: task),
                              ));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to create task screen, passing the current project ID
          final bool? taskCreated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(projectId: projectId),
            ),
          );

          if (!mounted) return; // Add mounted check for async operations

          if (taskCreated == true) {
            _tasksRefetch?.call(); // Refetch tasks when a new one is created
          }
        },
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
