import 'package:flutter_test/flutter_test.dart';
import 'package:ott_frontend/main.dart';

void main() {
  testWidgets('App boots and shows Home route', (tester) async {
    await tester.pumpWidget(const OttApp());

    // Expect to find "Home" text from placeholder on initial route.
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Navigation buttons exist on home', (tester) async {
    await tester.pumpWidget(const OttApp());
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Player'), findsOneWidget);
  });
}
