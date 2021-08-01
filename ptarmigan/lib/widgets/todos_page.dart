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
import 'package:ptarmigan/amplifyconfiguration.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/widgets/add_feed_form.dart';
import 'package:ptarmigan/widgets/feeds_list.dart';
import 'package:ptarmigan/widgets/todo_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'dart:convert';

class TodosPage extends StatefulWidget {
  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  List<Todo> todos;
  List<Feed> _feeds;
  List<Feed> _feedsSub;

  bool _isLoading;
  bool isSignUpComplete;
  StreamSubscription _subscription;
  StreamSubscription _subscriptionFeed;
  StreamSubscription _subscriptionFeedSub;
  StreamSubscription _subscriptionTodoUpdate;

  List<Todo> _todos;

  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);

  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

  @override
  void initState() {
    _isLoading = true;
    _todos = [];
    _feeds = [];
    _feedsSub = [];
    _initializeApp();
    super.initState();
  }

  @override
  void dispose() {
    // cancel the subscription when the state is removed from the tree
    _subscription.cancel();
    _subscriptionFeed.cancel();
    _subscriptionFeedSub.cancel();
    _subscriptionTodoUpdate.cancel();

    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    await _configureAmplify();

    // listen for updates to Todo entries by passing the Todo classType to
    // Amplify.DataStore.observe() and when an update event occurs, fetch the
    // todo list
    //
    // note this strategy may not scale well with larger number of entries
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      _fetchTodos();
    });

    _subscriptionFeed =
        Amplify.DataStore.observe(Feed.classType).listen((event) {
      _fetchFeeds();
    });

    _subscriptionFeedSub =
        Amplify.DataStore.observe(Feed.classType).listen((event) {
      _fetchSubFeeds();
    });

    // fetch Todo entries from DataStore
    await _fetchTodos();
    await _fetchFeeds();
    await _fetchSubFeeds();
    // after both configuring Amplify and fetching Todo entries, update loading
    // ui state to loaded state
    setState(() {
      _isLoading = false;
    });
  }

  //---------------------------------------------------------------------
  //Beginning of signing in flow

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      //await Amplify.addPlugins([_dataStorePlugin]);

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

  Future<void> _fetchTodos() async {
    try {
      // query for all Todo entries by passing the Todo classType to
      // Amplify.DataStore.query()
      List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType);

      // update the ui state to reflect fetched todos
      setState(() {
        _todos = updatedTodos;
      });
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }
  }

  Future<void> _fetchFeeds() async {
    try {
      // query for all Todo entries by passing the Todo classType to
      // Amplify.DataStore.query()
      List<Feed> updatedFeed = await Amplify.DataStore.query(Feed.classType);

      // update the ui state to reflect fetched todos
      setState(() {
        _feeds = updatedFeed;
        print("\n========================\n");
        print(_feeds.toString());
      });
    } catch (e) {
      print('An error occurred while querying Feeds: $e');
    }
  }

  Future<void> _fetchSubFeeds() async {
    try {
      // query for all Todo entries by passing the Todo classType to
      // Amplify.DataStore.query()
      List<Feed> updatedFeed = await Amplify.DataStore.query(Feed.classType,
          where: Feed.SUBSCRIBEDTO.eq(0));

      // update the ui state to reflect fetched todos
      setState(() {
        _feedsSub = updatedFeed;
        print("\n==========SUB FEEDS==============\n");
        print(_feeds.toString());
      });
    } catch (e) {
      print('An error occurred while querying Feeds: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insight Posts"),
        backgroundColor: Color(0xff488286),
      ),
      //body: Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TodosList(todos: _todos),
      drawer: FeedsList(
        feeds: _feeds,
        feedsSub: _feedsSub,
      ),
    );
  }
}

void _bottomSheetMore(context, points) {
  String responseBody =
      '[{"BeginDate": 1623005418000,"EndDate": 1623610218000,"IntervalData": 1.0}]';

  // parsePhotos(responseBody);
  final fromDate = DateTime(2021, 05, 22);
  final toDate = DateTime.now();
  final date1 = DateTime.now().subtract(Duration(days: 2));
  final date2 = DateTime.now().subtract(Duration(days: 3));

  final List<DataPoint<DateTime>> graphPoints = points;

  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return new Container(
        height: 240,
        padding: EdgeInsets.only(
          left: 5.0,
          right: 5.0,
          top: 0,
          bottom: 0,
        ),
        decoration: new BoxDecoration(
          color: Color(0xff232d37),
        ),
        child: Center(
            child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: Color(0xff232d37)),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 12.0, left: 12.0, top: 0, bottom: 20),
            child: BezierChart(
              fromDate: fromDate,
              bezierChartScale: BezierChartScale.WEEKLY,
              toDate: toDate,
              selectedDate: toDate,
              series: [
                BezierLine(
                  lineColor:
                      Colors.white, //Color(0xffff8811), //Color(0xff02d39a),
                  lineStrokeWidth: 2.0,
                  label: "Duty",
                  onMissingValue: (dateTime) {
                    if (dateTime.day.isEven) {
                      return 10.0;
                    }
                    return 5.0;
                  },
                  data: //graphPoints
                      const [],
                ),
              ],
              config: BezierChartConfig(
                verticalIndicatorStrokeWidth: 3.0,
                verticalIndicatorColor: Colors.black26,
                showVerticalIndicator: true,
                verticalIndicatorFixedPosition: false,
                backgroundColor: Color(0xff232d37),
                footerHeight: 50.0,
              ),
            ),
          ),
        )),
      );
    },
  );
}