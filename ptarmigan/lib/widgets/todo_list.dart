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
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class TodosList extends StatelessWidget {
  List<Todo> todos;
  final List<Feed> feeds;
  StreamSubscription _subscription;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TodosList({this.todos, this.feeds});

  bocko(var feedChoice) async {
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      fetchNewTodos(feedChoice);
    });

    await fetchNewTodos(feedChoice);
  }

  Future<void> fetchNewTodos(var feedIdentifier) async {
    print("KONO: " + feedIdentifier);
    List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType,
        where: Todo.NAME.eq(feedIdentifier));
    todos = updatedTodos;
    //print("VACO: " + todos.elementAt(0).name);
  }

  @override
  Widget build(BuildContext context) {
    var feedChoice = Provider.of<FeedChanger>(context).getFeedChoice;

    bocko(feedChoice);

    print('\n======================');
    print(todos.toString());
    print('======================\n');

    return Scaffold(
        key: scaffoldKey,
        body: Container(
          width: double.infinity,
          height: 500,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: PageView(
                  controller: pageViewController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    todos.length >= 1
                        ? ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            children: todos
                                .map((todo) => TodoItem(todo: todo))
                                .toList())
                        : Center(child: Text('')),
                    ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
