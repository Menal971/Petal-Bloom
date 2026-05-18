import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petal_notes/main.dart';

void main() {
  testWidgets('PetalApp renders HomeScreen smoke test',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const PetalApp());

    // Allow async operations (like initial API fetch) to settle
    await tester.pump(const Duration(seconds: 1));

    // Verify the app title or key UI element is present
    expect(find.text('Petal Notes'), findsOneWidget);
  });

  testWidgets('HomeScreen shows loading or content',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PetalApp());

    // Right after build, a loading indicator may be shown
    await tester.pump();

    // Either a CircularProgressIndicator or list content should be present
    final hasLoader =
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasContent = find.byType(ListView).evaluate().isNotEmpty;

    expect(hasLoader || hasContent, true);
  });
}
