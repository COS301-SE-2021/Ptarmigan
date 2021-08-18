// @dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'responsive.dart';
import 'package:ptarmigan/widgets/feed_items.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/models/Feed.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:provider/provider.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'package:ptarmigan/feedSentiment.dart';

class SideMenu extends StatelessWidget {
  final List<Todo> todos;
  final List<Feed> feeds;
  final List<Feed> feedsSub;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;

  SideMenu({this.todos, this.feeds, this.feedsSub, this.title});

  List<DrawerListTile> changeFeedsTo(List<Feed> feedList) {
    List<DrawerListTile> object;

    if (feedList == null) {
      return null;
    }

    for (int i = 0; i < feedList.length; i++) {
      DrawerListTile ob = new DrawerListTile();
      ob.title = feedList[0].feedName;
      ob.svgSrc = "assets/icons/menu_tran.svg";
      object.add(ob);
    }

    return object;
  }

  @override
  Widget build(BuildContext context) {
    Amplify.DataStore.clear();

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
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text("Add New  "),
                ),
              ])
            ]),
          ),
          // Column(children: null //changeFeedsTo(feedsSub),
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

  @override
  Widget build(BuildContext context) {
    void _changeFeed() {
      Provider.of<FeedChanger>(context, listen: false).changeFeed(this.title);
    }

    Future<FeedSentiment> _updateFeedPosts(String feedName) async {
      //Amplify.DataStore.clear();
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
            "BeginDate": 1623005418, //lastUpdated //replace for newest
            "Interval": "Week",
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
          print(
              "----------------------------------------------------------------");
          print(DateTime.fromMillisecondsSinceEpoch(test1[i].beginDate)
              .toIso8601String()
              .substring(0, 10));

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
      onTap: () {
        _changeFeed();

        _updateFeedPosts(title);
      },
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
    );
  }
}
