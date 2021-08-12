import 'dart:io';
import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_embed_webview/platforms/twitter.dart';
import 'package:social_embed_webview/social_embed_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late AuthUser _user;
  @override
  void initState() {
    print("Home page loaded.");
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
    // Amplify.Auth.getCurrentUser().then((user) {
    //  setState(() {
    //   _user = user;
    // });
    // }).catchError((error) {
    //   print(error.message as AuthException);
    //  });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            MaterialButton(
                onPressed: () {
                  Amplify.Auth.signOut().then((_) {
                    Navigator.pushReplacementNamed(context, '/login');
                  });
                },
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        //Drawer
        drawer: Drawer(),
        body: WebView(
          initialUrl:
              'https://twitter.com/ZacksJerryRig/status/1424895584075354118',
          //'https://www.youtube.com/watch?v=HNODkS9gZmM',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}
