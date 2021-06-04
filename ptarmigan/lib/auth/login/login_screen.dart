import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<String> _onLogin(BuildContext context, LoginData data) async {
    print(data);
    return "hi";
  }

  Future<String> _onSignup(BuildContext context, LoginData data) async {
    try {
      final res = await Amplify.Auth.signUp(
          username: data.name, password: data.password);
    } catch (e) {}
    return "hi";
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: "Ptarmigan",
      onSignup: (LoginData data) => _onSignup(context, data),
      onLogin: (LoginData data) => _onLogin(context, data),
      onRecoverPassword: (_) => Future.value(''),
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
      ),
      onSubmitAnimationCompleted: () {},
    );
  }
}
