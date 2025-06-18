import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_management_app/api/graphql_queries.dart';
import 'package:project_management_app/widgets/user_role_badge.dart'; // We will create this

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Query(
        options: QueryOptions(
          document: gql(getUsersQuery),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
        ),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.isLoading && result.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }
          final List? users = result.data?['users'];
          if (users == null || users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (refetch != null) {
                await refetch();
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: user['isActive']
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                      child: Text(
                        '${user['firstName']?[0] ?? ''}${user['lastName']?[0] ?? ''}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    title: Text('${user['firstName']} ${user['lastName']}',
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(user['email'] ?? 'No email',
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: UserRoleBadge(role: user['role'] ?? ''),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
