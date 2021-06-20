// @dart=2.9
// dart async library we will refer to when setting up real time updates
import 'dart:async';
// flutter and ui libraries
import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ptarmigan/entry.dart';
import 'package:ptarmigan/notifications/notification_service.dart';

import 'package:ptarmigan/screens/dashboard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
//import 'amplifyconfiguration.dart';
import 'auth/flutter_login/login_screen.dart';
import 'auth/login/confirm.dart';
import 'models/ModelProvider.dart';
import 'models/Todo.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp((MaterialApp(home: MyApp())));
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String current_stock = "No stock selected";

  @override
  void initState() {
    super.initState();
    NotificationService().setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(current_stock),
      ),
      body: new Center(
        child: new ElevatedButton(
          onPressed: () {
            notify_and_setState("stockname", 'This is a notification');
          },
          child: new Text(
            'Tap to have your mind blown',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }

  void notify_and_setState(String stockname, String message) {
    setState(() {
      current_stock = stockname;
    });
    //NotificationService().showNotification(stockname, message);
    //NotificationService().schedule_notification(stockname, message, DateTime(6,20,17,34)); //13 July 12:00
    NotificationService().schedule_notification(stockname, message,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 20)));
  }
}

class onSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Selected notification"),
      ),
      body: new Center(
        child: new FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(
            'Tap to go back to notification button screen',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
