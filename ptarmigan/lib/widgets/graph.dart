// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:ptarmigan/feedSentiment.dart';
import 'package:ptarmigan/widgets/SentimentHistory.dart';

import '../../../constants.dart';

// flutter and ui libraries
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:provider/provider.dart';
// amplify configuration and models that should have been generated for you
import 'package:bezier_chart/bezier_chart.dart';
//for feeds go to feeds_list.dart
import 'package:ptarmigan/services/list_changer.dart';
import '/models/SentimentHistoryItem.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import 'package:ptarmigan/FeedSentiment.dart' as FeedSent;
import 'package:http/http.dart' as http;
import '../models/Todo.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import '../models/Feed.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

List<Todo> todosGraph = [];

List<DataPoint<dynamic>> list = [];

class _GraphState extends State<Graph> {
  Future<String> fetchNewTodos(var feedIdentifier) async {
    try {
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();
      print("PPPPPEEEEEEEEEEEEEEEEEGGGGGGGGGGGG");
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
        List<dynamic> response = jsonDecode(response2
            .body /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        // print("HERE: " + response[0].intervalData.toString());

        //  List<FeedSentiment> sentimentFeed = List<FeedSentiment.fromJson(map));
        List<FeedSentiment> test1 = List<FeedSentiment>.from(
            response.map((i) => FeedSentiment.fromJson(i)));

        todosGraph = [];
        for (int i = 0; i < test1.length; i++) {
          int len = test1[i].intervalData.toString().indexOf(".") + 1;
          TemporalDate a = TemporalDate.fromString(
              DateTime.fromMillisecondsSinceEpoch(test1[i].beginDate * 1000)
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
            description: ((double.parse(test1[i].intervalData) * 50) + 50)
                .toString()
                .substring(0, 2),

            date:
                a, //TemporalDate.fromMillisecondsSinceEpoch(test1[0].beginDate);
          );
          todosGraph.add(newTodo);
        }
        //convertToGraph(test1);
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        throw Exception('Failed to create post.');
      }
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }

    return "found";
  }

  void convertToGraph(List<Todo> entry) {
    SentimentHistoryItem newItem = new SentimentHistoryItem();
    list = [];
    for (int i = 0; i < entry.length; i++) {
      print("plick: " + (double.parse(entry[i].description)).toString());
      list.add(new DataPoint<DateTime>(
        value: (double.parse(entry[i].description)),
        xAxis: DateTime.parse(entry[i].date.toString()),
      )); //DateTime.parse(entry[i].date.toString())));

    }

    // SentimentHistoryItem newItem = new SentimentHistoryItem("assets/icons/Negative.svg" ,todos[i].date,todos[i].description, "0");
    //  demoRecentFiles.add(newItem);
  }

  //build---------------------------------------------------------------

  Widget build(BuildContext context) => FutureBuilder(
      future: fetchNewTodos(Provider.of<FeedChanger>(context)
          .getFeedChoice), //Provider.of<FeedChanger>(context).getFeedChoice),

      builder: (context, snapshot) {
        final fromDate = DateTime(2021, 06, 15);
        final toDate = DateTime.now();

        final date1 = DateTime.now().subtract(Duration(days: 2));
        final date2 = DateTime.now().subtract(Duration(days: 3));
        fetchNewTodos(Provider.of<FeedChanger>(context).getFeedChoice);
        convertToGraph(todosGraph);

        for (int i = 0; i < list.length; i++) {
          print("PORK: " + list[i].value.toString());
        }

        if (snapshot.hasData == true) {
          return Container(
            //Grapg Container
            height: 240,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.only(
              left: 0.0,
              right: 0.0,
              top: 40,
              bottom: 0,
            ),
            child: Container(
              width: 800,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.black45),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 0.0, left: 0.0, top: 0, bottom: 20),
                child: BezierChart(
                  fromDate: fromDate,
                  bezierChartScale: BezierChartScale.WEEKLY,
                  toDate: toDate,
                  selectedDate: toDate,
                  series: [
                    BezierLine(
                      lineColor: Colors.green,
                      lineStrokeWidth: 2.0,
                      //   label: "Dutysdas",

                      data: list,
                      /*     [
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 14))),
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 13))),
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 12))),
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 11))),
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 10))),
                        DataPoint<DateTime>(
                            value: 45,
                            xAxis: DateTime.now().subtract(Duration(days: 9))),
                        DataPoint<DateTime>(
                            value: 48,
                            xAxis: DateTime.now().subtract(Duration(days: 8))),
                        DataPoint<DateTime>(
                            value: 56,
                            xAxis: DateTime.now().subtract(Duration(days: 7))),
                        DataPoint<DateTime>(
                            value: 54,
                            xAxis: DateTime.now().subtract(Duration(days: 6))),
                        DataPoint<DateTime>(
                            value: 44,
                            xAxis: DateTime.now().subtract(Duration(days: 5))),
                        DataPoint<DateTime>(
                            value: 48,
                            xAxis: DateTime.now().subtract(Duration(days: 4))),
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 3))),
                        DataPoint<DateTime>(
                            value: 53,
                            xAxis: DateTime.now().subtract(Duration(days: 2))),
                        DataPoint<DateTime>(
                            value: 50,
                            xAxis: DateTime.now().subtract(Duration(days: 1))),
                      ],*/
                    ),
                  ],
                  config: BezierChartConfig(
                    verticalIndicatorStrokeWidth: 3.0,
                    verticalIndicatorColor: Colors.black26,
                    showVerticalIndicator: true,
                    verticalIndicatorFixedPosition: false,
                    footerHeight: 50.0,
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      });
/*
    return Center(
        child: AspectRatio(
            aspectRatio: 1.90,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xff232d37)),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: BezierChart(
                  fromDate: fromDate,
                  bezierChartScale: BezierChartScale.MONTHLY,
                  toDate: toDate,
                  selectedDate: toDate,
                  series: [
                    BezierLine(
                      label: "Sentiment",
                      onMissingValue: (dateTime) {
                        if (dateTime.day.isEven) {
                          return 10.0;
                        }
                        return 5.0;
                      },
                      data: [
                        DataPoint<DateTime>(value: 10, xAxis: date1),
                        DataPoint<DateTime>(value: 50, xAxis: date2),
                        DataPoint<DateTime>(value: 50, xAxis: date2),
                      ],
                    ),
                  ],
                  config: BezierChartConfig(
                    verticalIndicatorStrokeWidth: 3.0,
                    verticalIndicatorColor: Colors.white,
                    showVerticalIndicator: true,
                    verticalIndicatorFixedPosition: false,
                    footerHeight: 30.0,
                  ),
                ),
              ),
            )));
  }*/
//}

}
