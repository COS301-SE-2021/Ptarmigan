// @dart=2.9

//import 'dart:js';

//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ptarmigan/basic_notification_main.dart';
import 'package:ptarmigan/notifications/notification_service.dart';

class MockBuildContext extends Mock implements BuildContext {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  testWidgets('Test to see if button calls notification service.',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyApp()));

    await tester.tap(find.byType(ElevatedButton));

    await tester.pump();

    expect(find.text('stockname'), findsOneWidget);
  });

  testWidgets("Test to confirm usability of clicking on the notification",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyApp()));
    //NotificationService().showNotification("Filler_text1", "Message_filler1");
    //await NotificationService().selectNotification("Not used at the moment");
    BuildContext context = tester.element(find.byType(ElevatedButton));
    NotificationService().setContext(context);

    await NotificationService().selectNotification("hi");
    await tester.pump();
    var foundButton = find.byType(FloatingActionButton);
    print(foundButton.toString());
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
