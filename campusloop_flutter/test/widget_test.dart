import 'package:flutter_test/flutter_test.dart';
import 'package:campusloop_flutter/main.dart';

void main() {
  testWidgets('CampusLoopApp initializes smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusLoopApp());
    expect(find.byType(CampusLoopApp), findsOneWidget);
  });
}
