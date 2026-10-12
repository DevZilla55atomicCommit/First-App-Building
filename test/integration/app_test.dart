// Integration test placeholder
// Run with: flutter test integration_test/app_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app_building/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App integration test', () {
    testWidgets('App launches and shows home screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify app launches
      expect(find.text('First App Building'), findsOneWidget);
    });
  });
}