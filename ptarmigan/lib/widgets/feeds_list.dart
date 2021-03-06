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
import 'package:ptarmigan/widgets/add_feed_form.dart';
import 'package:ptarmigan/widgets/feed_items.dart';
import 'package:ptarmigan/widgets/graph.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class FeedsList extends StatelessWidget {
  final List<Todo> todos;
  final List<Feed> feeds;
  final List<Feed> feedsSub;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;
  FeedsList({this.todos, this.feeds, this.feedsSub, this.title});

  @override
  Widget build(BuildContext context) {
    // Amplify.DataStore.clear();
    print('|||||||||||||||||FEED LIST IS BUILDING||||||||||||||||||||||||');
    return Container(
      alignment: Alignment.center,
      width: 270,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Container(
              color: Color(0xffCEE1E4),
              key: Key("ListView_container"),
              child: feedsSub.length >= 1
                  ? ListView(
                      key: Key('ListView'),
                      padding: EdgeInsets.fromLTRB(0, 190, 0, 0),
                      scrollDirection: Axis.vertical,
                      children: feedsSub
                          .map((feedsSub) => FeedItems(feed: feedsSub))
                          .toList())
                  : Center(child: Text(''))),
          DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff07424B),
              ),
              child: Column(
                key: Key("ColumnOne"),
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 90, 0),
                      child: Text(
                        'Feeds',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Montserrat"),
                      )),
                  Container(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 120, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddFeedForm(feeds: feeds)));
                      },
                      child: Text('Add Feed',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xff02d39a))),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black45, textStyle: TextStyle()),
                    ),
                  )),
                ],
              )),
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
