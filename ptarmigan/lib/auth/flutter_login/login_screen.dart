// @dart=2.9
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:ptarmigan/models/ModelProvider.dart';

import '../../amplifyconfiguration.dart';

final AmplifyDataStore _dataStorePlugin =
    AmplifyDataStore(modelProvider: ModelProvider.instance);

final AmplifyAPI _apiPlugin = AmplifyAPI();
final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

bool amplifyConfigured = false;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginData _data;
  bool _isSignedIn = false;

  Future<String> _onLogin(LoginData data) async {
    print("--LOGIN--");
    Amplify.Auth.signOut();
    try {
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );

      _isSignedIn = res.isSignedIn;
    } on AuthException catch (e) {
      print('Message ============ ' + e.message);
      if (e.message.contains('There is already a user  signed in.')) {
        await Amplify.Auth.signOut();
        return 'Problem logging in. Please try again.';
      }
      //await Amplify.Auth.signOut();   /////////////////////////////////////////MAKE SHIFT SOLUTION ---- NEEDS FIXING
      //return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String> _onRecoverPassword(BuildContext context, String email) async {
    print("--RECOVER PASS--");
    try {
      final res = await Amplify.Auth.resetPassword(username: email);

      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        Navigator.of(context).pushReplacementNamed(
          '/confirm-reset',
          arguments: LoginData(name: email, password: ''),
        );
      }
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<String> _onSignup(LoginData data) async {
    try {
      print("attempting sign up" + data.name);
      await Amplify.Auth.signUp(
        username: data.name,
        password: data.password,
        options: CognitoSignUpOptions(userAttributes: {
          'email': data.name,
        }),
      );

      _data = data;
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }

  Future<void> _initState() async {
    print("ATTEMPTING CONFIG");
    if (amplifyConfigured == false) {
      amplifyConfigured = true;
      await _configureAmplify();
    }
  }

  @override
  Widget build(BuildContext context) {
    _initState();
    print("====Amplify configure finished====");
    return FlutterLogin(
      title: 'Welcome',
      onLogin: _onLogin,
      onRecoverPassword: (String email) => _onRecoverPassword(context, email),
      onSignup: _onSignup,
      theme: LoginTheme(
        primaryColor: Theme.of(context).primaryColor,
      ),
      onSubmitAnimationCompleted: () {
        print("Pushing replacement choice : " + _data.name);
        Navigator.of(context).pushReplacementNamed(
          _isSignedIn ? '/home' : '/confirm',
          arguments: _data,
        );
      },
    );
  }

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      //await Amplify.addPlugins([_dataStorePlugin]);
      print("=====AMPLIFY CONFIGURING=====");
      await Amplify.addPlugins([
        _dataStorePlugin,
        _apiPlugin,
        _authPlugin,
      ]);
      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
    }
  }
}
