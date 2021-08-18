//@dart=2.9
//flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// The application under test.
import 'package:ptarmigan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Login flow test: Correct username and password',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      tester.takeException();
      final Finder findEmail = find.widgetWithText(TextField, "Email");
      print(findEmail.description);
      final Finder findPassword = find.widgetWithText(TextField, "Password");
      print(findPassword.description);
      //tester.tap(findEmail);
      await tester.enterText(findEmail, "lukebshs@gmail.com");
      await tester.enterText(findPassword, "Hello#123");
      await tester.pumpAndSettle();
      //  MaterialButton button =
      Finder findSubmit = find.text('LOGIN');

      // button.onPressed;
      await tester.tap(findSubmit);
      await tester.pumpAndSettle();

      final Finder findText = find.text("Ptarmigan");
      expect(findText, findsOneWidget);
    });

    testWidgets('Test Text widgets on homescreen/dashboard.',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      tester.takeException();
      final findText = find.text("Ptarmigan");
      expect(findText, findsOneWidget);

      expect(find.text("Curious about our info?"), findsOneWidget);
      expect(find.text("Click here for the tweet!"), findsOneWidget);
      expect(find.text("Have a look at the most impactful tweet of the day!"),
          findsOneWidget);
    });

    testWidgets("Navigate to Stock screen", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      tester.takeException();
      await tester.tap(find.text("Stocks"));
      await tester.pumpAndSettle();

      expect(find.text("Historical stock data"), findsOneWidget);
    });

    /*testWidgets(
        "Stock screen: insure atleast one row of datatable2 is displayed.",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find, matcher)

    });*/

    /*testWidgets('Dashboard displays correctly', (WidgetTester tester) async {
      runApp(DashboardScreen());
      await tester.pumpAndSettle();
      expect(find.widgetWithText(Text, "Ptarmigan"), findsOneWidget);
    });*/
  });
}
