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
import 'package:ptarmigan/widgets/feed_items_admin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class FeedsListAdmin extends StatelessWidget {
  final List<Todo> todos;
  final List<Feed> feeds;

  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FeedsListAdmin({this.todos, this.feeds});

  @override
  Widget build(BuildContext context) {
    return Container(
      //  width: 280,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 220, 0, 0),
                child: Row(
                  children: [Text("Bob")],
                )),
          ),
        ],
      ),
    );
    /*
    PageView(
        controller: pageViewController,
        scrollDirection: Axis.horizontal,
        children: [
         
        ]); */
  }
}
