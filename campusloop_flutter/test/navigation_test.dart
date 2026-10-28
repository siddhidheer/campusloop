import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusloop_flutter/screens/app_shell.dart';
import 'package:campusloop_flutter/screens/discover/discover_screen.dart';

void main() {
  testWidgets('AppShell.switchTab correctly toggles between Events (0) and Study Partners (1)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppShell(
          key: GlobalKey(),
        ),
      ),
    );
    await tester.pump();

    final contextFinder = find.byType(Scaffold);
    expect(contextFinder, findsWidgets);
    final innerContext = tester.element(contextFinder.first);

    // 1. Switch to Partners (subTab: 1)
    AppShell.switchTab(innerContext, 1, subTab: 1);
    await tester.pumpAndSettle();

    final discoverFinder1 = find.byType(DiscoverScreen);
    expect(discoverFinder1, findsOneWidget);
    var indexedStacks = tester.widgetList<IndexedStack>(
      find.descendant(of: discoverFinder1, matching: find.byType(IndexedStack)),
    );
    expect(indexedStacks.first.index, equals(1), reason: 'Should show Study Partners on subTab: 1');

    // 2. Switch to Events (subTab: 0)
    AppShell.switchTab(innerContext, 1, subTab: 0);
    await tester.pumpAndSettle();

    final discoverFinder2 = find.byType(DiscoverScreen);
    expect(discoverFinder2, findsOneWidget);
    indexedStacks = tester.widgetList<IndexedStack>(
      find.descendant(of: discoverFinder2, matching: find.byType(IndexedStack)),
    );
    expect(indexedStacks.first.index, equals(0), reason: 'Should show Events on subTab: 0');

    // 3. Switch back to Partners (subTab: 1)
    AppShell.switchTab(innerContext, 1, subTab: 1);
    await tester.pumpAndSettle();

    final discoverFinder3 = find.byType(DiscoverScreen);
    expect(discoverFinder3, findsOneWidget);
    indexedStacks = tester.widgetList<IndexedStack>(
      find.descendant(of: discoverFinder3, matching: find.byType(IndexedStack)),
    );
    expect(indexedStacks.first.index, equals(1), reason: 'Should switch back to Study Partners on subTab: 1');
  });
}
