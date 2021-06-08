import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ptarmigan/auth/login/confirm.dart';
import 'package:ptarmigan/models/ModelProvider.dart';

import '../../amplifyconfiguration.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginData _data = LoginData(name: '', password: '');

  void initState() {
    super.initState();
    // _configureAmplify();
  }

  void _configureAmplify() async {
    final AmplifyAuthCognito auth = AmplifyAuthCognito();

    await Amplify.addPlugins([auth]);

    await Amplify.configure(amplifyconfig);
  }

  Future<String> _onLogin(BuildContext context, LoginData data) async {
    await Amplify.Auth.signIn(
      username: data.name,
      password: data.password,
    );
    return "hi";
  }

  Future<String> _onSignup(BuildContext context, LoginData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name,
        password: data.password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': data.name,
        }),
      );
      _data = data;
    } on AuthException catch (e) {
      //return e.message;
      return (e.message);
    }
    //return "Not success";
    //return "Confirmation email sent.";
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
      onSubmitAnimationCompleted: () {
        Navigator.of(context)
            .pushReplacementNamed('/confirm', arguments: _data);
      },
    );
  }
}
