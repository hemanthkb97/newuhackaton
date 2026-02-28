import 'package:flutter_test/flutter_test.dart';
import 'package:breathing_app/app.dart';
import 'package:breathing_app/injection_container.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    initDependencies();
    await tester.pumpWidget(const BreathingApp());
    expect(find.text('Set your breathing pace'), findsOneWidget);
  });
}
