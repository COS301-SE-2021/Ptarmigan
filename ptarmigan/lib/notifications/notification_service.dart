// @dart=2.9

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/*
  Instantiate in main.dart using :
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().init();
  then make use of the NotificationService() object
  eg: 
    NotificationService().showNotification("example_stock", "example message")
*/

//singleton object
class NotificationService {
  static const channel_id = "123";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    tz.initializeTimeZones();
  }

  Future selectNotification(String payload) async {
    //when notification is selected
  }

  void showNotification(String stockname, String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        stockname.hashCode,
        "Ptarmigan",
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channel_id, "Ptarmigan", 'To inform you of stock sentiments')),
        payload:
            "/dashboard"); // when the notification is tapped we want to navigate to dashboard
  }

  //for testing purposes
  Future<String> onpress_showNotification(
      String stockname, String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        stockname.hashCode,
        "Ptarmigan",
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channel_id, "Ptarmigan", 'To inform you of stock sentiments')),
        payload:
            "/dashboard"); // when the notification is tapped we want to navigate to dashboard
    return stockname;
  }

  Future<void> schedule_notification(String stockname, String notificationMessage,
      DateTime daysToBeRemindedIn) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        (stockname + daysToBeRemindedIn.toString()).hashCode,
        "Ptarmigan",
        notificationMessage,
        //daysToBeRemindedIn, //going to need to pass it a customized datetime object
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 20)), //for testing purposes
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, "Ptarmigan",
                "To remind you about your hold on for dear life reminder")),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
