import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptarmigan/services/sentiment_prediction_generator.dart';

import '../../../constants.dart';
import 'ProgressBar.dart';
import 'package:http/http.dart' as http;
import 'package:ptarmigan/services/FeedStockSentiment.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/services/feed_changer.dart';

class StockAndSentimentValues extends StatelessWidget {
  String currentSentiment = "50";
  String currentStock = "759";
  String tomorrowsSentiment = "0";
  String prediction = "Decrease";
  String feedName = "Bitcoin";

  Color colorDetermine(int i) {
    Color a = Colors.green;

    if (i < 30) {
      a = Colors.red;
    }

    if (i >= 30 && i <= 65) {
      a = Colors.amber;
    }

    if (i > 65) {
      a = Colors.green;
    }

    return a;
  }

  String getCurrentSentiment() {
    return currentSentiment;
  }

  Future<void> fetchNewStock(var feedIdentifier) async {
    try {
      feedName = feedIdentifier;
      print("Alpha");
      await fetchPrediction(feedIdentifier);
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
        List<dynamic> response = jsonDecode(response2
            .body /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        // print("HERE: " + response[0].intervalData.toString());

        //  List<FeedSentiment> sentimentFeed = List<FeedSentiment.fromJson(map));
        List<FeedStockSentiment> test1 = List<FeedStockSentiment>.from(
            response.map((i) => FeedStockSentiment.fromJson(i)));

        currentSentiment = test1[test1.length - 1].sentiment;
        currentStock = test1[test1.length - 1].stock;

        print("hobp: " +
            (double.parse(currentSentiment) * 50 + 50)
                .toString()
                .substring(0, 2));
        // ((int.parse(currentSentiment) * 50 + 50)
        //     .toString()
        //    .substring(0, 2)));
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
    print("BORK");
  }

  Future<void> fetchPrediction(var feedIdentifier) async {
    try {
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();
      print("beta");
      final response2 = await http.post(
          Uri.parse(
              'https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/prediction'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"context": feedIdentifier}));
      print("hotel");

      if (response2.statusCode == 200) {
        print(response2.body);

        print("delta");

        // print("HERE: " + response[0].intervalData.toString());

        //  List<FeedSentiment> sentimentFeed = List<FeedSentiment.fromJson(map));
        //List<FeedStockSentiment> test1 = List<FeedStockSentiment>.from(
        //    response.map((i) => FeedStockSentiment.fromJson(i)));

        // currentSentiment = test1[test1.length - 1].sentiment;
        // currentStock = test1[test1.length - 1].stock;
        print("prediction");
        String b = response2.body;
        prediction = b;
        prediction = prediction.substring(1, prediction.length - 1);
        // ((int.parse(currentSentiment) * 50 + 50)
        //     .toString()
        //    .substring(0, 2)));
      } else if (response2.statusCode == 400) {
        prediction = "Unavailable (Crypto)";
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print("zeta");
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
    print("BORK");
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: fetchNewStock(Provider.of<FeedChanger>(context).getFeedChoice),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          // Build the widget with data.
          return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current Sentiment:  " +
                      (double.parse(currentSentiment) * 50 + 50)
                          .toString()
                          .substring(0, 2) +
                      "%",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                ProgressBar(
                  color: colorDetermine(int.parse(
                      (double.parse(currentSentiment) * 50 + 50)
                          .toString()
                          .substring(0, 2))),
                  percentage: int.parse(
                      (double.parse(currentSentiment) * 50 + 50)
                          .toString()
                          .substring(0, 2)),
                ),
                Text(""),
                Text(
                  "Current Stock Price: \$" + currentStock,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(1, 8, 1, 1),
                  child: Text(
                    "Tomorrow's stock prediction: ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(1, 4, 1, 1),
                  child: Text(
                    prediction,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          );
        } else {
          // We can show the loading view until the data comes back.
          return CircularProgressIndicator();
        }
      });
}
