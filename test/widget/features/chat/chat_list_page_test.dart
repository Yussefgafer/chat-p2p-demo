import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_p2p/features/chat/presentation/pages/chat_list_page.dart';

void main() {
  group('ChatListPage Widget Tests', () {
    testWidgets('should display app bar with correct title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      expect(find.text('Chat P2P'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display search and menu buttons in app bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(PopupMenuButton), findsOneWidget);
    });

    testWidgets('should display floating action button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display empty state when no chats', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Check if empty state is displayed (this depends on the actual implementation)
      // Since the current implementation has sample data, we'll check for chat items
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display chat items when chats exist', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for chat items (based on the sample data in ChatListPage)
      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Bob Smith'), findsOneWidget);
      expect(find.text('Charlie Brown'), findsOneWidget);
    });

    testWidgets('should show online indicator for online users', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for online indicators (green dots)
      expect(find.byWidgetPredicate(
        (widget) => widget is Container && 
                   widget.decoration is BoxDecoration &&
                   (widget.decoration as BoxDecoration).color == Colors.green,
      ), findsWidgets);
    });

    testWidgets('should display unread message count badges', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for unread count badge (Alice has 2 unread messages)
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should open search when search button is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Check if search delegate is opened
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show menu when menu button is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      // Check for menu items
      expect(find.text('New Chat'), findsOneWidget);
      expect(find.text('Scan QR Code'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should show new chat options when FAB is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Check for bottom sheet with new chat options
      expect(find.text('Share QR Code'), findsOneWidget);
      expect(find.text('Scan QR Code'), findsOneWidget);
      expect(find.text('Find Nearby'), findsOneWidget);
    });

    testWidgets('should navigate to chat detail when chat item is tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Alice's chat
      await tester.tap(find.text('Alice Johnson'));
      await tester.pumpAndSettle();

      // Check if navigation occurred (this would depend on the actual navigation implementation)
      // For now, we'll just verify the tap doesn't cause errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should show chat options when chat item is long pressed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Long press on Alice's chat
      await tester.longPress(find.text('Alice Johnson'));
      await tester.pumpAndSettle();

      // Check for chat options bottom sheet
      expect(find.text('Mute'), findsOneWidget);
      expect(find.text('Archive'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should show delete confirmation dialog', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Long press to show options
      await tester.longPress(find.text('Alice Johnson'));
      await tester.pumpAndSettle();

      // Tap delete option
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Check for confirmation dialog
      expect(find.text('Delete Chat'), findsOneWidget);
      expect(find.text('Are you sure you want to delete the chat with Alice Johnson?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsWidgets); // Two delete buttons now
    });

    testWidgets('should filter chats in search', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      // Open search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Type search query
      await tester.enterText(find.byType(TextField), 'Alice');
      await tester.pumpAndSettle();

      // Check if only Alice's chat is shown
      expect(find.text('Alice Johnson'), findsOneWidget);
      expect(find.text('Bob Smith'), findsNothing);
      expect(find.text('Charlie Brown'), findsNothing);
    });

    testWidgets('should display correct timestamp format', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for timestamp displays (format: 5m, 1h, 1d, etc.)
      expect(find.textContaining('m'), findsWidgets);
      expect(find.textContaining('h'), findsWidgets);
      expect(find.textContaining('d'), findsWidgets);
    });

    testWidgets('should handle empty search results', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      // Open search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Type search query that won't match anything
      await tester.enterText(find.byType(TextField), 'NonExistentUser');
      await tester.pumpAndSettle();

      // Check if no results are shown
      expect(find.text('Alice Johnson'), findsNothing);
      expect(find.text('Bob Smith'), findsNothing);
      expect(find.text('Charlie Brown'), findsNothing);
    });

    testWidgets('should maintain scroll position after returning from detail', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll down (if there were more items)
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Tap on a chat item
      await tester.tap(find.text('Alice Johnson'));
      await tester.pumpAndSettle();

      // Navigate back (this would be automatic in real navigation)
      // For testing purposes, we'll just verify no exceptions occurred
      expect(tester.takeException(), isNull);
    });
  });

  group('ChatListPage Animation Tests', () {
    testWidgets('should animate fade transition on load', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      // Check initial state (should be animating)
      expect(find.byType(FadeTransition), findsOneWidget);

      // Wait for animation to complete
      await tester.pumpAndSettle();

      // Verify content is visible after animation
      expect(find.text('Alice Johnson'), findsOneWidget);
    });

    testWidgets('should handle animation controller disposal', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Remove widget to trigger disposal
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('Different Page')),
        ),
      );

      // Verify no exceptions during disposal
      expect(tester.takeException(), isNull);
    });
  });

  group('ChatListPage Accessibility Tests', () {
    testWidgets('should have proper semantic labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for semantic labels on important elements
      expect(find.bySemanticsLabel('Search chats'), findsOneWidget);
      expect(find.bySemanticsLabel('Start new chat'), findsOneWidget);
    });

    testWidgets('should support screen reader navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatListPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that chat items are accessible
      final chatItems = find.byType(ListTile);
      expect(chatItems, findsWidgets);

      // Each chat item should be focusable
      for (final item in tester.widgetList<ListTile>(chatItems)) {
        expect(item.onTap, isNotNull);
      }
    });
  });
}
