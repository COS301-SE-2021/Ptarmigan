import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterScreen extends StatelessWidget {
  // ignore: non_constant_identifier_names
  late String twitter_url;
  TwitterScreen(url) {
    twitter_url = "https://twitter.com/user/status/";
    twitter_url += url;
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
      body: WebView(
        initialUrl: twitter_url,
        //'https://www.youtube.com/watch?v=HNODkS9gZmM',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
