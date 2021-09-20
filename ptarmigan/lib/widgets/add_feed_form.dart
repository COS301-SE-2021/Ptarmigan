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

class AddFeedForm extends StatefulWidget {
  List<Feed> feeds;
  AddFeedForm({this.feeds});

  @override
  _AddFeedFormState createState() => _AddFeedFormState(feeds: feeds);
}

class _AddFeedFormState extends State<AddFeedForm> {
  _AddFeedFormState({this.feeds});
  List<Feed> feeds = [new Feed()];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  Future<void> _saveFeed() async {
    // get the current text field contents
    String name = _nameController.text;
    String description = _descriptionController.text;
    String tags = _descriptionController.text;

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    Feed newFeed = Feed(
        feedName: name,
        description: description.isNotEmpty ? description : null,
        tags: tags);

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newFeed);
      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Feed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Feed'),
      ),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: ListView() //FeedsListAdmin(feeds: feeds),
          ),
    );
  }
}
