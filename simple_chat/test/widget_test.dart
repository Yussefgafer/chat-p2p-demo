// This is a basic Flutter widget test for Simple Chat app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_chat/main.dart';

void main() {
  testWidgets('Simple Chat app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Verify that the app title is displayed
    expect(find.text('Chat P2P - تجريبي'), findsOneWidget);

    // Verify that demo header is displayed
    expect(find.text('Chat P2P Demo'), findsOneWidget);
    expect(find.text('تطبيق دردشة لامركزي آمن'), findsOneWidget);

    // Verify that demo chat items are displayed
    expect(find.text('أحمد محمد'), findsOneWidget);
    expect(find.text('فاطمة علي'), findsOneWidget);
    expect(find.text('محمد حسن'), findsOneWidget);
    expect(find.text('سارة أحمد'), findsOneWidget);

    // Test floating action button
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Chat item tap test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Find and tap on first chat item
    await tester.tap(find.text('أحمد محمد'));
    await tester.pump();

    // Verify that demo dialog appears
    expect(find.text('محادثة مع أحمد محمد'), findsOneWidget);
    expect(find.text('هذه نسخة تجريبية من التطبيق.'), findsOneWidget);
  });

  testWidgets('New chat button test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Tap the floating action button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that new chat dialog appears
    expect(find.text('محادثة جديدة'), findsOneWidget);
    expect(find.text('في النسخة الكاملة، ستتمكن من:'), findsOneWidget);
  });

  testWidgets('Info button test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Find and tap the info button
    await tester.tap(find.byIcon(Icons.info));
    await tester.pump();

    // Verify that about dialog appears
    expect(find.text('Chat P2P Demo'), findsOneWidget);
    expect(
      find.text('تطبيق دردشة لامركزي مع تشفير كامل من طرف إلى طرف.'),
      findsOneWidget,
    );
  });
}
