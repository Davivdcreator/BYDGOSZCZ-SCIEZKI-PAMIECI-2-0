import 'package:flutter_test/flutter_test.dart';
import 'package:sciezki_pamieci/app.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SciezkiPamieciApp());

    // Verify that onboarding screen loads
    expect(find.text('Ścieżki Pamięci'), findsOneWidget);
  });
}
