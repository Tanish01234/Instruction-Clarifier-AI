import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:instruction_clarifier_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: InstructionClarifierApp(),
      ),
    );

    // Verify the app title is rendered
    expect(find.text('Instruction Clarifier AI'), findsOneWidget);

    // Verify tagline exists
    expect(
      find.textContaining('We didn\'t make AI smarter'),
      findsOneWidget,
    );
  });
}
