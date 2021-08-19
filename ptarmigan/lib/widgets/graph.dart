// @dart=2.9

import 'dart:async';
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

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<DataPoint<dynamic>> list = [];

  Widget build(BuildContext context) {
    List listChoice = Provider.of<ListChanger>(context).getList;
    final fromDate = DateTime(2021, 06, 15);
    final toDate = DateTime.now();

    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

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
          padding:
              const EdgeInsets.only(right: 0.0, left: 0.0, top: 0, bottom: 20),
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
                onMissingValue: (dateTime) {
                  if (dateTime.day.isEven) {
                    return 50;
                  }
                  return 50;
                },
                data: //listChoice, //graphPoints
                    [
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
                ],
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
}
