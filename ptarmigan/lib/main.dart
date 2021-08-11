// @dart=2.9
// dart async library we will refer to when setting up real time updates
import 'dart:async';
// flutter and ui libraries
import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/widgets/home_page.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';

import 'auth/flutter_login/login_screen.dart';
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

void main() {
  //_configureAmplify();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //_configureAmplify();
    print("Displaying login screen");
    return MultiProvider(
        providers: [
           ChangeNotifierProvider.value(
            value: FeedChanger(),
          ),
        ],
        child: MaterialApp(
          title: 'Amplified Todo',
          //home: TodosPage(),
          //home: Login(),
          initialRoute: '/login',
          routes: {
            '/login': (context) => Login(),
            '/home': (context) => DashboardScreen(), // REPLACE WITH HOME SCREEN
            '/insights': (context) => TodosPage()
            '/confirm': (context) => 
          },
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


//Feeds===============================================================

