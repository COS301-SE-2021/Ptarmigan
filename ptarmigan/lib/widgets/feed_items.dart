// @dart=2.9

import 'dart:async';
import 'dart:convert';
// flutter and ui libraries
import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/feedSentiment.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class FeedItems extends StatelessWidget {
  final double iconSize = 24.0;
  final Feed feed;

  FeedItems({this.feed});

  void _deleteFeed(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(feed);
    } catch (e) {
      print('An error occurred while deleting Insight: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    void _changeFeed() {
      Provider.of<FeedChanger>(context, listen: false)
          .changeFeed(feed.feedName);
    }

    void _updateFeedPosts(String b) {
      String a =
          '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      List<dynamic> response = jsonDecode(a);
      // List<FeedSentiment> sentimentFeed = List<FeedSentiment.fromJson(map));
      List<FeedSentiment> test1 = List<FeedSentiment>.from(
          response.map((i) => FeedSentiment.fromJson(i)));

      for (int i = 0; i < 4; i++) {
        print("HOPE");
        print(test1[i].beginDate);
      }

      DateTime.fromMillisecondsSinceEpoch(test1[0].beginDate);

      //  for (int i = 0; i < sentimentFeed.length; i++) {
      //   String _dateController = sentimentFeed[i].beginDate;
      //  String _descriptionController = sentimentFeed[i].intervalData;

      // get the current text field contents
      //   String date = _dateController;
      //    String description = _descriptionController;

      // create a new Todo from the form values
      // `isComplete` is also required, but should start false in a new Todo
      Todo newTodo = Todo(
          //     name: name,
          //     description: description.isNotEmpty ? description : null,
          //     date: date,
          );
      print("TRIGGERED JSON");
      try {
        // to write data to DataStore, we simply pass an instance of a model to
        // Amplify.DataStore.save()
        //   Amplify.DataStore.save(newTodo);
        // after creating a new Todo, close the form
        //  Navigator.of(context).pop();
      } catch (e) {
        print('An error occurred while saving Todo: $e');
      }
    }
    //  }

    return Card(
      color: Colors.white,
      child: InkWell(
        onLongPress: () {
          _deleteFeed(context);
        },
        onTap: () {
          // update the ui state to reflect fetched todos
          // feedID.value = feed.feedName;
          _changeFeed();
          _updateFeedPosts("as");
          //print(feedID.value);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feed.feedName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(feed.description ?? ''),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
