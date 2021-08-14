import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterScreen extends StatelessWidget {
  const TwitterScreen({ Key? key }) : super(key: key);

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
  initialUrl:
  'https://twitter.com/ZacksJerryRig/status/1424895584075354118',
  //'https://www.youtube.com/watch?v=HNODkS9gZmM',
  javascriptMode: JavascriptMode.unrestricted,
  ),
    );
  }
}