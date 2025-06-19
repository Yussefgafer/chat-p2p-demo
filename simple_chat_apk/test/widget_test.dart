// Chat P2P Demo Widget Tests
//
// Tests for the Chat P2P demo application

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_chat_apk/main.dart';

void main() {
  testWidgets('Chat P2P app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Verify that the app title is displayed
    expect(find.text('Chat P2P - تجريبي'), findsOneWidget);

    // Verify that the demo header is displayed
    expect(find.text('Chat P2P Demo'), findsOneWidget);
    expect(find.text('تطبيق دردشة لامركزي آمن'), findsOneWidget);

    // Verify that demo chats are displayed
    expect(find.text('أحمد محمد'), findsOneWidget);
    expect(find.text('فاطمة علي'), findsOneWidget);

    // Verify that the floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Chat item tap shows dialog', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Tap on the first chat item
    await tester.tap(find.text('أحمد محمد'));
    await tester.pumpAndSettle();

    // Verify that the dialog is shown
    expect(find.text('محادثة مع أحمد محمد'), findsOneWidget);
    expect(find.textContaining('نسخة تجريبية'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('موافق'));
    await tester.pumpAndSettle();
  });

  testWidgets('New chat button shows dialog', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Tap on the floating action button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the new chat dialog is shown
    expect(find.text('محادثة جديدة'), findsOneWidget);
    expect(find.textContaining('النسخة الكاملة'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('موافق'));
    await tester.pumpAndSettle();
  });

  testWidgets('About dialog shows correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChatP2PApp());

    // Tap on the info button in app bar
    await tester.tap(find.byIcon(Icons.info));
    await tester.pumpAndSettle();

    // Verify that the about dialog is shown
    expect(find.textContaining('تشفير كامل'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('موافق'));
    await tester.pumpAndSettle();
  });
}
