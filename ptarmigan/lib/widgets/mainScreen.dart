// @dart=2.9

import 'dart:async';

import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:ptarmigan/services/feed_file_manager.dart';
import '../controllers/MenuController.dart';
import 'responsive.dart';
import 'dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/amplifyconfiguration.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'sideMenu.dart';
import 'package:ptarmigan/widgets/feeds_list.dart';
import 'package:ptarmigan/widgets/todo_list.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class MainScreen extends StatefulWidget {
  FeedFileManager manager; // <<------ File manager passed from Home screen

  MainScreen(this.manager);

  @override
  _MainScreenState createState() => _MainScreenState(manager);
}

class _MainScreenState extends State<MainScreen> {
  List<Todo> todos;
  List<Feed> _feeds;
  List<Feed> _feedsSub;
  String currentFeedSelected = " ";
  bool _isLoading;
  bool isSignUpComplete;
  FeedFileManager manager; // <<------ File manager passed from Home screen
  Widget _body = Scaffold(body: Container(child: CircularProgressIndicator()));

  StreamSubscription _subscription;
  StreamSubscription _subscriptionFeed;
  StreamSubscription _subscriptionFeedSub;
  StreamSubscription _subscriptionTodoUpdate;

  List<Todo> _todos;
  String _feedTitle;

  //final AmplifyDataStore _dataStorePlugin =
  // AmplifyDataStore(modelProvider: ModelProvider.instance);

//  final AmplifyAPI _apiPlugin = AmplifyAPI();
  //final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

  _MainScreenState(this.manager);

  @override
  void initState() {
    print("Initializing mainScreen.dart ----");
    //print(manager.getNamesAndSubMap());

    _isLoading = true;
    _todos = [];
    _feeds = [];
    _feedsSub = [];
    //_initFeedsSub();
    //_initFeeds();
    _initFeedMap(); // <<------ Initialized feedsSub and feeds
    //_initializeTemp();
    super.initState();
  }

  _initFeedsSub() async {
    manager.getNamesAndSubMap().then((value) => {
          setState(() {
            _feedsSub = transformListToSubFeedList(value);
          })
        });
  }

  _initFeeds() async {
    manager.getNamesAndSubMap().then((value) => {
          setState(() {
            _feeds = transformListToFeedList(value);
          })
        });
  }

  _initFeedMap() async {
    //var feedMap = await manager.getNamesAndSubMap();
    // print(feedMap.toString());

    manager.getNamesAndSubMap().then((value) => {
          // <<------ An await but the set state only takes place once a value is returned
          setState(() {
            _feeds = transformListToFeedList(value);
            _feedsSub = transformListToSubFeedList(value);
            _body =
                _replaceBody(); // Replaces body after _feeds and _feedsSub updated
          })
        });
  }

  List<Feed> transformListToSubFeedList(Map feeds) {
    //Takes feed map and returns List<feed> only of subscribed feeds
    print("feeds = $feeds");
    var tempNameList = feeds.keys.toList();
    print("Tempnamelist = $tempNameList");
    var tempSubList = feeds.values.toList();
    print("tempSubList = $tempSubList");
    List<Feed> tempFeedList = [];
    for (var i = 0; i < tempNameList.length; i++) {
      if (tempSubList[i] == "True") {
        //Only adds subscribed feeds
        Feed temp = Feed(
            feedName: tempNameList[i],
            subscribedTo: getFeedBoolAsInt(
              tempSubList[i],
            ));
        tempFeedList.add(temp);
      }
    }
    print("TRANSFORMSUBFEEDLIST RETURN = $tempFeedList");
    if (tempFeedList.isEmpty)
      return [new Feed(feedName: "Bitcoin", subscribedTo: 1)];
    else
      return tempFeedList;
  }

  //Map is <String, String> eg : {"Bitcoin" : "False"}
  List<Feed> transformListToFeedList(Map feeds) {
    // Takes feed map and returns List<feed>
    print("feeds = $feeds");
    var tempNameList = feeds.keys.toList();
    print("Tempnamelist = $tempNameList");
    var tempSubList = feeds.values.toList();
    print("tempSubList = $tempSubList");
    List<Feed> tempFeedList = [];
    for (var i = 0; i < tempNameList.length; i++) {
      //Only adds subscribed feeds
      Feed temp = Feed(
          feedName: tempNameList[i],
          subscribedTo: getFeedBoolAsInt(
            tempSubList[i],
          ));
      tempFeedList.add(temp);
    }
    print("TRANSFORMFEEDLIST RETURN = $tempFeedList");
    if (tempFeedList.isEmpty)
      return [new Feed(feedName: "Bitcoin", subscribedTo: 1)];
    else
      return tempFeedList;
  }

  int getFeedBoolAsInt(String value) {
    if (value == "False")
      return 0;
    else if (value == "True") return 1;
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

  Future<void> _initializeTemp() async {
    await _initializeApp();
  }

  Future<void> _initializeApp() async {
    // configure Amplify

    //await _configureAmplify();

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
    //setState(() {
    //  _isLoading = false;
    // });
  }

  //---------------------------------------------------------------------
  //Beginning of signing in flow

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      //await Amplify.addPlugins([_dataStorePlugin]);

      await Amplify.addPlugins([
        // _dataStorePlugin,
        // _apiPlugin,
        //  _authPlugin,
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
    Provider.of<FeedChanger>(context, listen: false).changeFeed("Bitcoin");

    // Amplify.DataStore.clear();
    return _body; // _body is a state, when the feedSub and feed are changed _replaceBody is called and the proper page displayed
  }

  Widget _replaceBody() {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(
        feeds: _feeds,
        feedsSub: _feedsSub,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(
                  feeds: _feeds,
                  feedsSub: _feedsSub,
                ),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: InsightsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
