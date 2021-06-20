// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptarmigan/basic_notification_main.dart';
import 'package:ptarmigan/notifications/notification_service.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  testWidgets('Testing the notification service using basic_notification_main',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyApp()));

    await tester.tap(find.byType(ElevatedButton));

    await tester.pump();

    expect(find.text('stockname'), findsOneWidget);
  });
}
