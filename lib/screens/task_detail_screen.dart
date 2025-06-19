import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(task['taskName'] ?? 'Task Details'),
        actions: [
          Mutation(
            options: MutationOptions(
              document: gql(deleteTaskMutation),
              onCompleted: (data) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, true);
                }
              },
            ),
            builder: (runMutation, result) {
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete Task',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            runMutation({'id': task['taskID']});
                            Navigator.pop(ctx);
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDetailRow(theme, 'Status', task['status'], color: Colors.green),
          _buildDetailRow(theme, 'Priority', task['priority'],
              color: Colors.orange),
          if (task['dueDate'] != null)
            _buildDetailRow(
                theme,
                'Due Date',
                DateTime.parse(task['dueDate'])
                    .toLocal()
                    .toString()
                    .substring(0, 10)),
          const SizedBox(height: 20),
          Text('Description', style: theme.textTheme.titleMedium),
          const Divider(),
          Text(task['description'] ?? 'No description provided.',
              style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: theme.textTheme.titleMedium),
          Text(value,
              style: theme.textTheme.titleMedium?.copyWith(
                  color: color ?? theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
