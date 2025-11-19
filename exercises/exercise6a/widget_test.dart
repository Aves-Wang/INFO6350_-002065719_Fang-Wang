import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/main.dart';
import 'package:flutter/material.dart';


void main() {
  testWidgets('Button input addition shows correct result', (WidgetTester tester) async {
    await tester.pumpWidget(CalculatorApp());

await tester.tap(find.byKey(Key('btn_2')));
await tester.pump();

await tester.tap(find.byKey(Key('btn_+')));
await tester.pump();

await tester.tap(find.byKey(Key('btn_3')));
await tester.pump();

await tester.tap(find.byKey(Key('btn_=')));
await tester.pump();

expect(find.text('5.0'), findsOneWidget);

  
  });

  testWidgets('Division by zero shows error', (WidgetTester tester) async {
    await tester.pumpWidget(CalculatorApp());

    // Tap '8'
    await tester.tap(find.byKey(Key('btn_8')));
    await tester.pump();


    // Tap '/'
    await tester.tap(find.byKey(Key('btn_/')));
    await tester.pump();
  

    // Tap '0'
   await tester.tap(find.byKey(Key('btn_0')));
   await tester.pump();


    // Tap '='
    await tester.tap(find.byKey(Key('btn_=')));
    await tester.pump();


    // Check if 'Error' is displayed
    expect(find.text('Error'), findsOneWidget);
  });
}
