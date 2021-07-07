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
import 'package:ptarmigan/feedSentiment.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'dart:convert';

class TodoItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Todo todo;

  TodoItem({this.todo});

  void _deleteTodo(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(todo);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  /* Future<void> _toggleIsComplete() async {
    // copy the Todo we wish to update, but with updated properties
    Todo updatedTodo = todo.copyWith(isComplete: !todo.isComplete);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  } */

  @override
  Widget build(BuildContext context) {
    var date1 = DateTime.now().subtract(Duration(days: 2));

    List<DataPoint<DateTime>> graphPoints = [];
    graphPoints.add(DataPoint<DateTime>(value: 10, xAxis: date1));

    return Card(
      child: InkWell(
        onTap: () {
          // _toggleIsComplete();
        },
        onLongPress: () {
          _bottomSheetMore(context, graphPoints);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(todo.description ?? 'No description'),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

void _bottomSheetMore(context, points) {
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
                  lineColor: Color(0xff02d39a),
                  lineStrokeWidth: 2.0,
                  label: "Duty",
                  onMissingValue: (dateTime) {
                    if (dateTime.day.isEven) {
                      return 10.0;
                    }
                    return 5.0;
                  },
                  data: graphPoints
                  //for (int i = 0; i < 10; i++) graphPoints[i],
                  ,
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

List<DataPoint> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<FeedSentiment>((json) => FeedSentiment.fromJson(json))
      .toList();
}
