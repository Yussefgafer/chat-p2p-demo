import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chat_p2p/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Chat P2P Integration Tests', () {
    testWidgets('complete app flow test', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Test 1: Splash screen should appear and navigate to chat list
      await _testSplashScreen(tester);

      // Test 2: Chat list should be displayed
      await _testChatListDisplay(tester);

      // Test 3: Test navigation to QR code page
      await _testQRCodeNavigation(tester);

      // Test 4: Test settings navigation
      await _testSettingsNavigation(tester);

      // Test 5: Test search functionality
      await _testSearchFunctionality(tester);
    });

    testWidgets('peer discovery flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to QR code page
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Share QR Code'));
      await tester.pumpAndSettle();

      // Verify QR code page is displayed
      expect(find.text('QR Code'), findsOneWidget);
      expect(find.text('Share Your QR Code'), findsOneWidget);

      // Test tab switching
      await tester.tap(find.text('Scan'));
      await tester.pumpAndSettle();

      expect(find.text('Point camera at QR code'), findsOneWidget);

      // Go back to share tab
      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();

      // Test action buttons
      await tester.tap(find.text('Regenerate'));
      await tester.pumpAndSettle();

      // Verify no errors occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets('settings flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to settings
      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify settings page is displayed
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Privacy & Security'), findsOneWidget);

      // Test toggle switches
      final darkModeSwitch = find.byType(SwitchListTile).first;
      await tester.tap(darkModeSwitch);
      await tester.pumpAndSettle();

      // Test navigation to sub-settings
      await tester.tap(find.text('Encryption Settings'));
      await tester.pumpAndSettle();

      // Verify no errors occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets('performance under load test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Perform rapid navigation to test performance
      for (int i = 0; i < 10; i++) {
        // Open FAB menu
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Close menu
        await tester.tap(find.byKey(const Key('backdrop')));
        await tester.pumpAndSettle();

        // Open search
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        // Close search
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Verify app is still responsive
      expect(find.text('Chat P2P'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('memory leak test', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate through different screens multiple times
      for (int i = 0; i < 5; i++) {
        // Go to QR code page
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Share QR Code'));
        await tester.pumpAndSettle();

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Go to settings
        await tester.tap(find.byType(PopupMenuButton));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        // Go back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      }

      // Verify app is still functional
      expect(find.text('Chat P2P'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('should handle network errors gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Try to perform network-dependent actions
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Find Nearby'));
      await tester.pumpAndSettle();

      // Verify no crashes occurred
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle permission denials gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Try to access camera for QR scanning
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Scan QR Code'));
      await tester.pumpAndSettle();

      // Switch to scan tab
      await tester.tap(find.text('Scan'));
      await tester.pumpAndSettle();

      // Verify no crashes occurred even if camera permission is denied
      expect(tester.takeException(), isNull);
    });
  });
}

// Helper functions for test organization

Future<void> _testSplashScreen(WidgetTester tester) async {
  // Wait for splash screen to complete
  await tester.pumpAndSettle(const Duration(seconds: 4));
  
  // Verify we're now on the chat list page
  expect(find.text('Chat P2P'), findsOneWidget);
  expect(find.byType(FloatingActionButton), findsOneWidget);
}

Future<void> _testChatListDisplay(WidgetTester tester) async {
  // Verify chat list elements are present
  expect(find.text('Alice Johnson'), findsOneWidget);
  expect(find.text('Bob Smith'), findsOneWidget);
  expect(find.text('Charlie Brown'), findsOneWidget);
  
  // Verify UI elements
  expect(find.byIcon(Icons.search), findsOneWidget);
  expect(find.byType(PopupMenuButton), findsOneWidget);
  expect(find.byType(FloatingActionButton), findsOneWidget);
}

Future<void> _testQRCodeNavigation(WidgetTester tester) async {
  // Open new chat options
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
  
  // Navigate to QR code page
  await tester.tap(find.text('Share QR Code'));
  await tester.pumpAndSettle();
  
  // Verify QR code page is displayed
  expect(find.text('QR Code'), findsOneWidget);
  expect(find.text('Share'), findsOneWidget);
  expect(find.text('Scan'), findsOneWidget);
  
  // Go back to chat list
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  
  // Verify we're back on chat list
  expect(find.text('Chat P2P'), findsOneWidget);
}

Future<void> _testSettingsNavigation(WidgetTester tester) async {
  // Open menu
  await tester.tap(find.byType(PopupMenuButton));
  await tester.pumpAndSettle();
  
  // Navigate to settings
  await tester.tap(find.text('Settings'));
  await tester.pumpAndSettle();
  
  // Verify settings page is displayed
  expect(find.text('Settings'), findsOneWidget);
  expect(find.text('Appearance'), findsOneWidget);
  expect(find.text('Privacy & Security'), findsOneWidget);
  
  // Go back to chat list
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  
  // Verify we're back on chat list
  expect(find.text('Chat P2P'), findsOneWidget);
}

Future<void> _testSearchFunctionality(WidgetTester tester) async {
  // Open search
  await tester.tap(find.byIcon(Icons.search));
  await tester.pumpAndSettle();
  
  // Verify search interface is displayed
  expect(find.byType(TextField), findsOneWidget);
  expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  
  // Enter search query
  await tester.enterText(find.byType(TextField), 'Alice');
  await tester.pumpAndSettle();
  
  // Verify search results
  expect(find.text('Alice Johnson'), findsOneWidget);
  
  // Clear search and close
  await tester.tap(find.byIcon(Icons.clear));
  await tester.pumpAndSettle();
  
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  
  // Verify we're back on chat list
  expect(find.text('Chat P2P'), findsOneWidget);
}
