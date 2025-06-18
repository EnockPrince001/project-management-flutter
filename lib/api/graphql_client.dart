// lib/api/graphql_client.dart
import 'package:flutter/foundation.dart'; // Import to check platform (kIsWeb)
import 'package:graphql_flutter/graphql_flutter.dart'; // Import for GraphQLClient

ValueNotifier<GraphQLClient> getGraphQLClient() {
  // Determine the correct URI based on the platform.
  // kIsWeb is a special constant that is true when the app is running in a web browser.
  // '10.0.2.2' is the special IP address to access the host machine's localhost from an Android emulator.
  // ignore: prefer_const_declarations
  final String host = kIsWeb ? 'localhost' : '10.0.2.2';
  // Use the fixed port for your backend: 5131
  final String uri = 'http://$host:5131/graphql';

  final HttpLink httpLink = HttpLink(uri);

  return ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache:
          GraphQLCache(store: HiveStore()), // Using Hive for persistent caching
    ),
  );
}
