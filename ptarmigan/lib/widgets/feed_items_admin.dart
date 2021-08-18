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
import 'package:ptarmigan/services/subscriber.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:ptarmigan/widgets/todos_page.dart';

class FeedItemsAdmin extends StatelessWidget {
  final double iconSize = 24.0;
  final Feed feed;

  FeedItemsAdmin({this.feed});

  void _deleteFeed(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(feed);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  Future<int> subscribeTo() async {
    // copy the Todo we wish to update, but with updated properties
    Feed updatedFeed;

    /*  if (feed.subscribedTo == 1) {
      updatedFeed = feed.copyWith(subscribedTo: 0);
    } else {
      updatedFeed = feed.copyWith(subscribedTo: 1);
    }*/
    updatedFeed =
        feed.copyWith(subscribedTo: Subscriber().subscribe(feed.subscribedTo));

    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedFeed);
      return feed.subscribedTo;
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onLongPress: () {},
        onTap: () {
          // update the ui state to reflect fetched todos
          // feedID.value = feed.feedName;
          subscribeTo();

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
                  Text(feed.description ?? 'No description'),
                ],
              ),
            ),
            Icon(
                feed.subscribedTo == 0
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
    );
  }
}
