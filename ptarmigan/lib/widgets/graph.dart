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
import 'package:ptarmigan/widgets/feeds_list_admin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bezier_chart/bezier_chart.dart';
//for feeds go to feeds_list.dart

class Graph extends StatefulWidget {
  List<Feed> feeds;
  Graph({this.feeds});

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  Widget build(BuildContext context) {
    final fromDate = DateTime(2021, 06, 15);
    final toDate = DateTime.now();

    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

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
                    backgroundColor: Colors.amber, // Color(0xff232d37),
                    footerHeight: 30.0,
                  ),
                ),
              ),
            )));
  }
}
