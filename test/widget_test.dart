import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cash_toss/main.dart';

void main() {
  testWidgets('Test adding expense', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that there are no expenses initially
    expect(find.text('No expenses added yet'), findsOneWidget);

    // Tap the '+' button and trigger the dialog
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Fill out the dialog fields and add an expense
    await tester.enterText(find.byType(TextField).at(0), 'Test Expense');
    await tester.enterText(find.byType(TextField).at(1), '100');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Verify that the expense is added to the list
    expect(find.text('Test Expense'), findsOneWidget);
    expect(find.text('₱100'), findsOneWidget);
  });
}
