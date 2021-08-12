// @dart=2.9

import 'dart:async';
// flutter and ui libraries
import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/widgets/feeds_list_admin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

//for feeds go to feeds_list.dart

class FrontPage extends StatefulWidget {
  List<Feed> feeds;
  FrontPage({this.feeds});

  @override
  _FrontPageState createState() => _FrontPageState(feeds: feeds);
}

class _FrontPageState extends State<FrontPage> {
  _FrontPageState({this.feeds});
  List<Feed> feeds;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        // child: ElevatedButton(onPressed: ,),
      ),
    );
  }
}
