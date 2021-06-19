import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:ptarmigan/amplifyconfiguration.dart';

import 'auth/flutter_login/login_screen.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool _amplifyconfigured = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _amplifyconfigured ? Login() : CircularProgressIndicator(),
      ),
    );
  }

  //configure amplify

  void _configureAmplify() async {
    final auth = AmplifyAuthCognito();

    // Configure amplify
    try {
      print('--------ATTEMPTING AMPLIFY CONFIG-----------');

      if (Amplify.isConfigured == false) {
        Amplify.addPlugins([auth]);
        //await Amplify.configure(amplifyconfig);
      }
      setState(() {
        _amplifyconfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
