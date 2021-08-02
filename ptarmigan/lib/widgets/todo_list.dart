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
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/widgets/feed_items.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:bezier_chart/bezier_chart.dart';

class TodosList extends StatelessWidget {
  List<Todo> todos;
  List<Feed> feeds;
  StreamSubscription _subscription;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TodosList({this.todos, this.feeds});

  bocko(var feedChoice) async {
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      fetchNewTodos(feedChoice);
    });

    await fetchNewTodos(feedChoice);
  }

  Future<void> fetchNewTodos(var feedIdentifier) async {
    print("KONO: " + feedIdentifier);
    List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType,
        where: Todo.NAME.eq(feedIdentifier));
    todos = updatedTodos;
    //print("VACO: " + todos.elementAt(0).name);
  }

  @override
  Widget build(BuildContext context) {
    var feedChoice = Provider.of<FeedChanger>(context).getFeedChoice;

    bocko(feedChoice);

    print('\n======================');
    print(todos.toString());
    print('======================\n');
    final fromDate = DateTime(2021, 05, 22);
    final toDate = DateTime.now();
    final date1 = DateTime.now().subtract(Duration(days: 2));
    final date2 = DateTime.now().subtract(Duration(days: 3));

    return Scaffold(
        key: scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                0.1,
                0.55,
                0.98,
                // 0.99,
              ],
                  colors: [
                Color(0xff488286),
                Color(0xff305252),
                Color(0xff3AAFB9),
                //Color(0xff093A3E),
                //  Color(0xff4087a1),
                //  Color(0xff0a5bad),
                //  Color(0xff044dc2),
              ])),
          width: double.infinity,
          height: 700,
          child: Stack(
            children: [
              Container(
                height: 240,
                padding: EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                  top: 0,
                  bottom: 0,
                ),
                child: Center(
                    child: Container(
                  decoration: const BoxDecoration(color: Colors.white10),
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
                          lineColor: Colors.white,
                          lineStrokeWidth: 2.0,
                          //   label: "Dutysdas",
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
                        footerHeight: 50.0,
                      ),
                    ),
                  ),
                )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 260, 0, 50),
                child: PageView(
                  controller: pageViewController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    todos.length >= 1
                        ? ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            children: todos
                                .map((todo) => TodoItem(todo: todo))
                                .toList())
                        : Center(child: Text('')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: null,
                      child: const Text('Disabled'),
                      autofocus: true,
                      clipBehavior: Clip.none,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
