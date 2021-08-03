// @dart=2.9
import 'package:amplify_auth_cognito/amplify_auth_cognito_stream_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

AndroidNotificationChannel channel;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class PushNotificationService {
  //Receiving messages

  Future<void> InitializeNotificationService() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    //runApp(MessagingExampleApp());
  }

  void _firebaseMessagingForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

//boiler plate example code
//void main() {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // runApp(MyApp());
//}

// subscribe to topic on each app start-up
//await FirebaseMessaging.instance.subscribeToTopic('weather');
//await FirebaseMessaging.instance.unsubscribeFromTopic('weather');

}
