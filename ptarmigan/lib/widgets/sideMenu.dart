// @dart=2.9

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptarmigan/widgets/SentimentHistory.dart';
import 'responsive.dart';
import 'package:ptarmigan/widgets/feed_items.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/models/Feed.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/services/list_changer.dart';

import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:provider/provider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'package:ptarmigan/feedSentiment.dart';
import '/models/SentimentHistoryItem.dart';
import 'package:ptarmigan/widgets/add_feed_form.dart';

class SideMenu extends StatelessWidget {
  List<Todo> todos;
  List<Feed> feeds;
  final List<Feed> feedsSub;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;
  StreamSubscription _subscription;

  SideMenu({this.todos, this.feeds, this.feedsSub, this.title});

  List<DrawerListTile> changeFeedsTo(List<Feed> feedList) {
    List<DrawerListTile> object = [];
    print("=====FEED LIST ===========");
    print(feedList);
    if (feedList == null) {
      return null;
    }

    for (int i = 0; i < feedList.length; i++) {
      DrawerListTile ob = new DrawerListTile();
      ob.title = feedList[i].feedName;
      ob.svgSrc = "assets/icons/menu_tran.svg";
      object.add(ob);
    }

    return object;
  }

  rocko() async {
    _subscription = Amplify.DataStore.observe(Feed.classType).listen((event) {
      fetchNewTodos();
    });

    await fetchNewTodos();
  }

  Future<void> fetchNewTodos() async {
    print("BOOOOOOOOR: ");
    List<Feed> updatedFeeds = await Amplify.DataStore.query(Feed.classType,
        where: Feed.SUBSCRIBEDTO.eq(0));

    feeds = updatedFeeds;

    //print("VACO: " + todos.elementAt(0).name);
  }

  @override
  Widget build(BuildContext context) {
    print("++++++++++++++++++++++++++++++");
    print(feeds[0].feedName);
    // Amplify.DataStore.clear();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(children: [
              Row(children: [
                Text("Ptarmigan", style: TextStyle(fontSize: 30))
              ]),
              Row(
                children: [
                  Text(
                    "Feeds",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              Row(children: [
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: 1 * 1.5,
                      vertical: 1 / (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFeedForm(feeds: feeds)));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add New  "),
                ),
              ])
            ]),
          ),
          Column(children: changeFeedsTo(feedsSub)),
          //  )
          /*   DrawerListTile(
            title: "Bitcoin",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Ethereum",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Amazon",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Microsoft",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "BMW",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Volkwagen",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ), */
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    // For selecting those three line once press "Command+D"
    String this.title,
    String this.svgSrc,
    VoidCallback this.press,
  });
  String title, svgSrc;
  VoidCallback press;

  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription _subscription;
  List<Todo> todos;

  List<DrawerListTile> changeFeedsTo(List<Feed> feedList) {
    List<DrawerListTile> object = [];

    if (feedList == null) {
      return null;
    }

    for (int i = 0; i < feedList.length; i++) {
      DrawerListTile ob = new DrawerListTile();
      ob.title = feedList[i].feedName;
      ob.svgSrc = "assets/icons/menu_tran.svg";
      object.add(ob);
    }

    return object;
  }

  rocko() async {
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      fetchNewTodos();
    });

    await fetchNewTodos();
  }

  Future<void> fetchNewTodos() async {
    List<Todo> updatedFeeds = await Amplify.DataStore.query(Todo.classType,
        where: Todo.NAME.eq(this.title));
    todos = updatedFeeds;
  }

  Future<void> Delete() async {
    List<Todo> deleteTodos = await Amplify.DataStore.query(Todo.classType,
        where: Todo.NAME.ne(this.title));

    for (int i = 0; i < deleteTodos.length; i++)
      await Amplify.DataStore.delete(deleteTodos[i]);
  }

  void PopulateDisplay(List<Todo> a) {
    for (int i = 0; i < 1; i++) {
      SentimentHistoryItem newItem = new SentimentHistoryItem();
      newItem.icon = "assets/icons/Negative.svg";
      newItem.title = "dasdad"; //todos[i].date.toString();
      newItem.date = "%69";
      //todos[i].description;
      newItem.size = "0";

      print("PINGED!!!!!!!!!!!!!!!!!!!");
      demoRecentFiles.add(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("feed changer function in sideMenu called");
    void _changeFeed() {
      print("feed changer function in sideMenu called");
      Provider.of<FeedChanger>(context, listen: false).changeFeed(this.title);
      Provider.of<ListChanger>(context, listen: false)
          .changeList(SentimentHistory().list);
    }

    String myTitle = this.title;
    Future<FeedSentiment> _updateFeedPosts(String feedName) async {
      Amplify.DataStore.clear();
      Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      final response2 = await http.post(
          Uri.parse(
              'https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/senthisize/getGraphSentiment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "BeginDate": 1627858371, //lastUpdated //replace for newest
            "Interval": "Day",
            "CompanyName": feedName
          }));
      print("-----------");
      print(response2.body);

      //  if (lastUpdated == 1623005418)
      //lastUpdated = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

      if (response2.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.

        List<dynamic> response = jsonDecode(response2.body
            .substring(response2.body.indexOf("["), response2.body.length - 1));

        // List<FeedSentiment> sentimentFeed = List<FeedSentiment.fromJson(map));
        List<FeedSentiment> test1 = List<FeedSentiment>.from(
            response.map((i) => FeedSentiment.fromJson(i)));

        for (int i = 0; i < test1.length; i++) {
          //  print("----------------------------------------------------------------");
          //   print(DateTime.fromMillisecondsSinceEpoch(test1[i].beginDate)
          //       .toIso8601String()
          //      .substring(0, 10));

          int len = test1[i].intervalData.toString().indexOf(".") + 1;
          TemporalDate a = TemporalDate.fromString(
              DateTime.fromMillisecondsSinceEpoch(test1[i].beginDate * 1000)
                  .toIso8601String()
                  .substring(0, 10));
          if (test1[i].intervalData < 0) {
            len = len - 1;
          }

          Todo newTodo = Todo(
            name: feedName,
            description: ((test1[i].intervalData) * 50 + 50)
                    .toString()
                    .substring(0, len) +
                "%",

            date:
                a, //TemporalDate.fromMillisecondsSinceEpoch(test1[0].beginDate);
          );

          try {
            print("Attempting to save to datastore");
            Amplify.DataStore.save(newTodo);

            // Navigator.of(context).pop();
          } catch (e) {
            print('An error occurred while saving Todo: $e');
          }
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        print(response2.statusCode);
        throw Exception('Failed to create post.');
      }

      /* DateTime tester = DateTime.fromMillisecondsSinceEpoch(test1[0].beginDate);
      tester.toIso8601String();

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
      } */
    }

    return ListTile(
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
      onTap: () {
        //  demoRecentFiles = [];
        _changeFeed();
        print("TIGGER1");

        _updateFeedPosts(myTitle);
        //   print("TIGGER2");
        SentimentHistory().fetchNewTodos(myTitle);

        //   rocko();
        //    print("TIGGER3");

        //PopulateDisplay(todos);
        //   print("TIGGER4");
      },
    );
  }
}
