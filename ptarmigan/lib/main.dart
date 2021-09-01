// @dart=2.9
// dart async library we will refer to when setting up real time updates

import '/constants.dart';
import 'controllers/MenuController.dart';
import 'widgets/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/services/list_changer.dart';
import 'package:ptarmigan/widgets/entry_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
          ChangeNotifierProvider.value(value: FeedChanger()),
          ChangeNotifierProvider.value(value: ListChanger())
        ],
        child: EntryScreen(), //MainScreen(),
      ),
    );
  }
}













//import 'dart:async';
// flutter and ui libraries
/*import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/auth/flutter_login/confirm_reset.dart';
import 'package:ptarmigan/auth/flutter_login/confirm_screen.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/widgets/home_page.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';

import 'auth/flutter_login/login_screen.dart';
import 'constants.dart';
import 'models/ModelProvider.dart';
import 'models/Todo.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

final ValueNotifier feedID = ValueNotifier("");

//final AmplifyDataStore _dataStorePlugin =
// AmplifyDataStore(modelProvider: ModelProvider.instance);

final AmplifyAPI _apiPlugin = AmplifyAPI();
final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
//List<Todo> todos;
//List<Feed> _feeds;
//List<Feed> _feedsSub;
bool pastFirstLaunch = false;

void main() {
  //_configureAmplify();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //_configureAmplify();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: FeedChanger(),
          ),
        ],
        child: MaterialApp(
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: bgColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                      .apply(bodyColor: Colors.white),
              canvasColor: secondaryColor,
            ),
            title: 'Amplified Todo',
            //home: TodosPage(),
            //home: Login(),
            //initialRoute: '/login',
            initialRoute: pastFirstLaunch == false ? '/login' : '/',
            // ignore: missing_return
            onGenerateRoute: (settings) {
              if (settings.name == '/confirm') {
                print("Navigator push : /CONFIRM");
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      ConfirmScreen(data: settings.arguments as LoginData),
                  transitionsBuilder: (_, __, ___, child) => child,
                );
              }
              if (settings.name == '/confirm-reset') {
                print("Navigator push : /CONFIRM");
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      ConfirmResetScreen(data: settings.arguments as LoginData),
                  transitionsBuilder: (_, __, ___, child) => child,
                );
              }
              if (settings.name == '/home') {
                //print("Navigator push : /HOME");
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DashboardScreen(),
                  transitionsBuilder: (_, __, ___, child) => child,
                );
              }
              if (settings.name == '/login') {
                pastFirstLaunch = true;
                //print("Navigator push : /LOGIN");
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Login(),
                  transitionsBuilder: (_, __, ___, child) => child,
                );
              }
              if (settings.name == '/insight') {
                // print("Navigator push : /INSIGHT");
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => TodosPage(),
                  transitionsBuilder: (_, __, ___, child) => child,
                );
              }
              if (settings.name == '/') {
                //print("Navigator push : /");
                return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DashboardScreen(),
                  transitionsBuilder: (_, __, ___, child) => child,
                );
              }
            }
            //routes: {
            // '/login': (context) => Login(),
            //  '/home': (context) => DashboardScreen(), // REPLACE WITH HOME SCREEN
            // '/insights': (context) => TodosPage(),
            // '/confirm': (context) => ConfirmScreen(),
            //},
            ));
  }
}

// FOR TESTING PURPOSES
class MyWidget extends StatelessWidget {
  const MyWidget({
    this.title,
    this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}


//Feeds=============================================================== */
