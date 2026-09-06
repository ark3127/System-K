import 'package:flutter_test/flutter_test.dart';

import 'package:system_k/main.dart';

void main() {
  testWidgets('App shows SYSTEM-K title', (WidgetTester tester) async {
    await tester.pumpWidget(const SystemKApp());

    expect(find.text('SYSTEM-K'), findsOneWidget);
  });
}
