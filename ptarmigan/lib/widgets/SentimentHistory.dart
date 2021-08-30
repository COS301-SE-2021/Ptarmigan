// @dart=2.9

import 'dart:async';
import 'dart:convert';

import '/models/SentimentHistoryItem.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import '../models/Todo.dart';
import '../models/Feed.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/models/TodoModel.dart';

import 'package:provider/provider.dart';
import 'package:ptarmigan/FeedSentiment.dart';
import '../../../constants.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:http/http.dart' as http;

class SentimentHistory extends StatelessWidget {
  StreamSubscription _subscription;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataPoint<dynamic>> list = [];
  List<Todo> todos = [];
  List<Feed> feeds = [];
  String feedTitle = "Bitcoin";

  SentimentHistory({this.todos, this.feeds});

/*  bocko(var feedChoice) async {
    print(
        "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      fetchNewTodos(feedChoice);
    });

    await fetchNewTodos(feedChoice);
  } */

  Future<void> fetchNewTodos(var feedIdentifier) async {
    try {
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      final response2 = await http.post(
          Uri.parse(
              'https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/senthisize/getDailySentiment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body:
              jsonEncode({"company": feedIdentifier, "beginDate": 1628899200}));

      if (response2.statusCode == 200) {
        print(response2.body);
        List<dynamic> response = jsonDecode(response2.body
            /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        // print("HERE: " + response[0].intervalData.toString());

        //  List<FeedSentiment> sentimentFeed = List<FeedSentiment.fromJson(map));
        List<FeedSentiment> test1 = List<FeedSentiment>.from(
            response.map((i) => FeedSentiment.fromJson(i)));

        print("HERE: " + test1[0].beginDate.toString());
        todos = [];
        for (int i = 0; i < test1.length; i++) {
          int len = test1[i].intervalData.toString().indexOf(".") + 1;
          TemporalDate a = TemporalDate.fromString(
              DateTime.fromMillisecondsSinceEpoch(
                      int.parse(test1[i].beginDate) * 1000)
                  .toIso8601String()
                  .substring(0, 10));

          if (double.parse(test1[i].intervalData) < 0) {
            len = len - 1;
          }
          print("ooooooooooooooooooooooooooooo");
          print((((test1[i].intervalData)).toString().substring(0, len) + "%")
              .toString());

          Todo newTodo = Todo(
            name: "Tesla",
            description: (double.parse(test1[i].intervalData) * 50 + 50)
                    .toString()
                    .substring(0, 2) +
                "%",

            date:
                a, //TemporalDate.fromMillisecondsSinceEpoch(test1[0].beginDate);
          );
          todos.add(newTodo);
        }
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        print(response2.statusCode);
        throw Exception('Failed to create post.');
      }
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }

    //------------------------------------------------------------------------------------
    //  print("KONO: " + feedIdentifier);
    // List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType,
    //      where: Todo.NAME.eq(feedIdentifier));
    //  print("KONO2: " + updatedTodos.length.toString());

    // todos = updatedTodos;
    //   feedTitle = feedIdentifier;

    //convertToGraph(updatedTodos);

    //print("VACO: " + todos.elementAt(0).name);
  }

  String colorPicker(String a) {
    String colorIcon = "assets/icons/Negative.svg";

    if (a.compareTo("30%") < 0) {
      colorIcon = "assets/icons/Negative.svg";
    } else if (a.compareTo("67%") < 0) {
      colorIcon = "assets/icons/Medium.svg";
    } else if (a.compareTo("67") > 0) {
      colorIcon = "assets/icons/Postive.svg";
    }
    return colorIcon;
  }

  /*Future<void> Delete(String name) async {
    List<Todo> deleteTodos = await Amplify.DataStore.query(Todo.classType,
        where: Todo.NAME.ne(name));

    for (int i = 0; i < deleteTodos.length; i++)
      await Amplify.DataStore.delete(deleteTodos[i]);
  } */

  void convertToGraph(List<Todo> entry) {
    SentimentHistoryItem newItem = new SentimentHistoryItem();
    demoRecentFiles = [];

    for (int i = 0; i < entry.length; i++) {
      print("plick");
      //  list.add(new DataPoint<DateTime>(
      //    value: 100, // double.parse(entry[i].description).toInt(),
      //     xAxis: DateTime.parse(entry[i].date.toString()),
      //  )); //DateTime.parse(entry[i].date.toString())));

      //convert to SentimentHistoryItem
      SentimentHistoryItem newItem = new SentimentHistoryItem();
      newItem.icon = colorPicker(todos[i].description);
      newItem.title = todos[i].date.toString();
      newItem.date = todos[i].description;
      newItem.size = "0";

      demoRecentFiles.add(newItem);
    }

    // SentimentHistoryItem newItem = new SentimentHistoryItem("assets/icons/Negative.svg" ,todos[i].date,todos[i].description, "0");
    //  demoRecentFiles.add(newItem);
  }

  @override
  Widget build(BuildContext context) {
    var feedChoice = Provider.of<FeedChanger>(context).getFeedChoice;
    fetchNewTodos(feedChoice);
    convertToGraph(todos);
    // bocko(feedChoice);
    //   Delete(feedChoice);
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sentiment History",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            height: 400,
            child: DataTable2(
              columnSpacing: 30,
              minWidth: 300,
              columns: [
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Sentiment"),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(SentimentHistoryItem fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              fileInfo.icon,
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date)),
    ],
  );
}