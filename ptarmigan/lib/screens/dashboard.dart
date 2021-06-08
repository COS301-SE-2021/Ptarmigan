import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late AuthUser _user;
  @override
  void initState() {
    super.initState();
    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
      });
    }).catchError((error) {
      print(error.message as AuthException);
    });
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
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [if (_user == null) Text('Loading') else Text("Hello")],
          ),
        ),
      ),
    );
  }
}
