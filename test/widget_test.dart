import 'package:flutter/material.dart'; // Import for ValueNotifier and other core Flutter widgets
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; // Import for GraphQLClient and HttpLink
import 'package:project_management_app/main.dart'; // Import our main app widget

void main() {
  testWidgets('App starts and shows "My Projects" title',
      (WidgetTester tester) async {
    // 1. Create a mock GraphQL client for testing purposes.
    // For widget tests, we don't need a live network connection.
    // InMemoryStore is suitable for testing, as it doesn't persist data.
    final ValueNotifier<GraphQLClient> testClient = ValueNotifier(
      GraphQLClient(
        link: HttpLink(
            'http://localhost:5131/graphql'), // Provide a dummy link, it won't be used
        cache: GraphQLCache(
            store: InMemoryStore()), // Use in-memory cache for tests
      ),
    );

    // 2. Build our app and trigger a frame, providing the mock client.
    // We pass the testClient to ProjectManagementApp's constructor.
    // Removed the 'const' keyword for ProjectManagementApp as its 'client' parameter
    // is not a compile-time constant.
    await tester.pumpWidget(
      ProjectManagementApp(client: testClient),
    );

    // 3. Verify that the AppBar title "My Projects" is displayed.
    // This confirms that the HomePage (the initial route) loads correctly.
    expect(find.text('My Projects'), findsOneWidget);

    // You can add more specific tests for your UI components as they evolve.
    // For instance, to test navigation to CreateProjectScreen:
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pumpAndSettle(); // Wait for navigation animation to complete
    // expect(find.text('Create New Project'), findsOneWidget);
  });
}
