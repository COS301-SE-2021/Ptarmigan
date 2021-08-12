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
    print("Home page loaded.");
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
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/insight');
            },
            child: Text('Insight page'),
          ),
        ),
      ),
    );
  }
}
