import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';

class CreateTaskScreen extends StatefulWidget {
  final int projectId;
  const CreateTaskScreen({super.key, required this.projectId});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _status = 'To Do';
  String _priority = 'Medium';

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: Mutation(
        options: MutationOptions(
            document: gql(createTaskMutation),
            onCompleted: (data) {
              if (mounted && data != null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Task created successfully!'),
                  backgroundColor: Colors.green,
                ));
                Navigator.pop(context, true);
              }
            },
            onError: (error) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Error: ${error?.graphqlErrors.first.message ?? error.toString()}'),
                  backgroundColor: Colors.red,
                ));
              }
            }),
        builder: (runMutation, result) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                      labelText: 'Task Name', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Task name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                      labelText: 'Status', border: OutlineInputBorder()),
                  items:
                      ['To Do', 'In Progress', 'Completed'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) => setState(() => _status = newValue!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: const InputDecoration(
                      labelText: 'Priority', border: OutlineInputBorder()),
                  items: ['Low', 'Medium', 'High'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => _priority = newValue!),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        labelText: 'Due Date', border: OutlineInputBorder()),
                    child: Text(_dueDate?.toIso8601String().substring(0, 10) ??
                        'Select date'),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      runMutation({
                        'input': {
                          'projectID': widget.projectId,
                          'taskName': _taskNameController.text,
                          'description': _descriptionController.text,
                          'status': _status,
                          'priority': _priority,
                          'dueDate': _dueDate?.toIso8601String(),
                        }
                      });
                    }
                  },
                  child: result?.isLoading ?? false
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Create Task'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
