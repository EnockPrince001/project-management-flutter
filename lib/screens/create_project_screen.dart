// lib/screens/create_project_screen.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart'; // Correct import for queries

// Extension to format DateTime for display (can be placed in a common utility file later)
extension DateOnlyCompare on DateTime {
  String toShortDateString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedUserId;

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (!mounted) return; // Guard against using context after dispose
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Project')),
      body: Query(
        options: QueryOptions(
            document: gql(
                getUsersForDropdownQuery)), // Correctly use the query string
        builder: (QueryResult userResult, {refetch, fetchMore}) {
          if (userResult.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userResult.hasException) {
            return Center(
                child: Text(
                    "Error loading users: ${userResult.exception.toString()}"));
          }
          final List<dynamic> users = userResult.data?['users'] ?? [];

          return Mutation(
            options: MutationOptions(
              document: gql(
                  createProjectMutation), // Correctly use the mutation string
              onCompleted: (dynamic resultData) {
                if (mounted && resultData != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Project created successfully!'),
                        backgroundColor: Colors.green),
                  );
                  Navigator.pop(
                      context, true); // Pop with a result to trigger refetch
                }
              },
              onError: (error) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Error: ${error?.graphqlErrors.isNotEmpty ?? false ? error!.graphqlErrors.first.message : error.toString()}'),
                        backgroundColor: Colors.red),
                  );
                }
              },
            ),
            builder: (RunMutation runMutation, QueryResult? mutationResult) {
              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    TextFormField(
                      controller: _projectNameController,
                      decoration: const InputDecoration(
                          labelText: 'Project Name',
                          border: OutlineInputBorder()),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    // Start Date Picker
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder()),
                        child: Text(
                            _startDate?.toIso8601String().substring(0, 10) ??
                                'Select date'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // End Date Picker
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            labelText: 'End Date (Optional)',
                            border: OutlineInputBorder()),
                        child: Text(
                            _endDate?.toIso8601String().substring(0, 10) ??
                                'Select date'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedUserId,
                      decoration: const InputDecoration(
                          labelText: 'Created By',
                          border: OutlineInputBorder()),
                      items: users.map<DropdownMenuItem<int>>((user) {
                        return DropdownMenuItem<int>(
                          value: user['userID'],
                          child:
                              Text('${user['firstName']} ${user['lastName']}'),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedUserId = value),
                      validator: (value) =>
                          value == null ? 'Please select a user' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _startDate != null &&
                            _selectedUserId != null) {
                          runMutation({
                            'input': {
                              'projectName': _projectNameController.text,
                              'description': _descriptionController.text,
                              'startDate': _startDate!.toIso8601String(),
                              'endDate': _endDate?.toIso8601String(),
                              'createdBy': _selectedUserId,
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please fill all required fields.'),
                                backgroundColor: Colors.orange),
                          );
                        }
                      },
                      child: mutationResult?.isLoading ?? false
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Create Project'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
