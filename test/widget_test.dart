// Reusable UI Component Widget Tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sessionchat/Widgets/elevatedbutton.dart';

void main() {
  testWidgets('CustomElevatedButton renders text and triggers onPressed', (WidgetTester tester) async {
    bool wasPressed = false;

    // Pump the custom button inside a MaterialApp wrapper
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomElevatedButton(
            text: 'Test Button',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    // Verify the button text renders correctly
    expect(find.text('Test Button'), findsOneWidget);

    // Tap the button and trigger a frame
    await tester.tap(find.text('Test Button'));
    await tester.pump();

    // Verify that the callback was successfully executed
    expect(wasPressed, isTrue);
  });
}
