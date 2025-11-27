import 'package:flutter_test/flutter_test.dart';
import 'package:ott_frontend/main.dart';

void main() {
  testWidgets('App boots and shows StreamView title', (tester) async {
    await tester.pumpWidget(const OttApp());
    await tester.pumpAndSettle();
    expect(find.text('StreamView'), findsOneWidget);
  });

  testWidgets('Bottom navigation exists', (tester) async {
    await tester.pumpWidget(const OttApp());
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsNothing); // new UI uses title 'StreamView'
    // Verify bottom nav items
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
