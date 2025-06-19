// This is a basic Flutter widget test for Chat P2P Demo app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chat_p2p/main.dart';

void main() {
  testWidgets('Chat P2P Demo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PDemoApp());

    // Wait for splash screen animation to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that the app title is displayed
    expect(find.text('Chat P2P Demo'), findsOneWidget);

    // Verify that demo chat items are displayed
    expect(find.text('Alice Johnson'), findsOneWidget);
    expect(find.text('Bob Smith'), findsOneWidget);

    // Test floating action button
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the floating action button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that demo dialog appears
    expect(find.text('Demo Version'), findsOneWidget);
  });

  testWidgets('Chat item tap test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PDemoApp());

    // Wait for splash screen animation to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Find and tap on first chat item
    await tester.tap(find.text('Alice Johnson'));
    await tester.pump();

    // Verify that demo dialog appears
    expect(find.text('Demo Version'), findsOneWidget);
    // Note: The dialog text might be different, let's check for the main dialog
    expect(find.textContaining('Alice Johnson'), findsOneWidget);
  });

  testWidgets('Menu actions test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PDemoApp());

    // Wait for splash screen animation to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Find and tap the menu button
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pump();

    // Verify menu items are displayed
    expect(find.text('About Demo'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);

    // Tap on About Demo
    await tester.tap(find.text('About Demo'));
    await tester.pump();

    // Verify about dialog appears
    expect(find.text('Chat P2P Demo'), findsOneWidget);
  });
}
