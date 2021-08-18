// @dart=2.9

import 'dart:async';

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
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'package:amplify_flutter/amplify.dart';

class SentimentHistory extends StatelessWidget {
  StreamSubscription _subscription;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataPoint<dynamic>> list = [];
  List<Todo> todos = [];
  List<Feed> feeds = [];
  String feedTitle = "Bitcoin";

  SentimentHistory({this.todos, this.feeds});

  bocko(var feedChoice) async {
    print(
        "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
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
    feedTitle = feedIdentifier;

    convertToGraph(updatedTodos);

    //print("VACO: " + todos.elementAt(0).name);
  }

  String colorPicker(String a) {
    return "";
  }

  void convertToGraph(List<Todo> entry) {
    SentimentHistoryItem newItem = new SentimentHistoryItem();
    demoRecentFiles = [];
    for (int i = 0; i < entry.length; i++) {
      print("plick");
      list.add(new DataPoint<DateTime>(
        value: 100, // double.parse(entry[i].description).toInt(),
        xAxis: DateTime.parse(entry[i].date.toString()),
      )); //DateTime.parse(entry[i].date.toString())));

      //convert to SentimentHistoryItem
      SentimentHistoryItem newItem = new SentimentHistoryItem();
      newItem.icon = "assets/icons/Negative.svg";
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
    feedChoice = feedChoice;
    bocko(feedChoice);

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
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Sentiment"),
                ),
                DataColumn(
                  label: Text("Size"),
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
      DataCell(Text(fileInfo.size)),
    ],
  );
}
