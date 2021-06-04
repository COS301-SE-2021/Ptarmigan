import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: "Ptarmigan",
      onSignup: (_) => Future.value(''),
      onLogin: (_) => Future.value(''),
      onRecoverPassword: (_) => Future.value(''),
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
      ),
      onSubmitAnimationCompleted: () {},
    );
  }
}
