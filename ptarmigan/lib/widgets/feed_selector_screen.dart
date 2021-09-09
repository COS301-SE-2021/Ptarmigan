import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/services/feed_file_manager.dart';

import '../constants.dart';

class FeedSelectorScreen extends StatefulWidget {
  FeedFileManager manager;
  FeedSelectorScreen(this.manager);

  @override
  _FeedSelectorScreenState createState() =>
      _FeedSelectorScreenState(this.manager);
}

class _FeedSelectorScreenState extends State<FeedSelectorScreen> {
  late List feedList;
  late List feedListBool;
  Map feedMap = Map();
  FeedFileManager manager;
  List feedFlag = [];

  bool feedListBoolFlag = false;
  bool feedMapInitialized = false;
  Widget _replaceMentBody = CircularProgressIndicator();
  Widget _body = CircularProgressIndicator();

  _FeedSelectorScreenState(this.manager);

  @override
  void initState() {
    //manager = new FeedFileManager();
    // TODO: implement initState
    _initFeedMap();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (feedListBoolFlag)
      return Scaffold(
        body: _body,
      );
    else
      return CircularProgressIndicator();
  }

  Widget replaceBody() {
    print("replaceBody called.");
    //print(feedListBool);
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: bgColor,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: DataTable2(
                columnSpacing: defaultPadding,
                minWidth: 400,
                columns: [
                  DataColumn(
                    label: Text("Stock name"),
                  ),
                  DataColumn(
                    label: Text("Subscribed"),
                  ),
                ],
                rows: List.generate(
                  feedMap.length,
                  (index) => recentFileDataRow(index),
                ),
              ),
            )));
  }

  DataRow recentFileDataRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(feedList[index]),
              ),
            ],
          ),
        ),
        DataCell(Row(
          children: [
            Text("Subscribe : "),
            Checkbox(
                value: feedListBool[index],
                onChanged: (bool? value) {
                  setState(() {
                    print("Index #$index clicked");
                    this.feedListBool[index] = value;
                    _body = replaceBody();
                  });
                  changeSubscribed(feedList[index]);
                })
          ],
        )),
        //DataCell(Text(("#"))),
      ],
    );
  }

  void changeSubscribed(String topic) {
    print("Change subscribed on $topic called");
    manager.changeSubscribed(topic);
  }

  _initFeedMap() async {
    manager.getNamesAndSubMap().then((value) => {
          setState(() {
            print("GetNamesAndSubMap called in setState");
            print("Value : $value");
            feedMap = value;
            feedList = value.keys.toList();
          }),
          getFeedListBool(value.values.toList()).then((value) => {
                setState(() {
                  print("Set state called in getFeedListBool");
                  feedListBoolFlag = true;
                  feedMapInitialized = true;
                  feedListBool = value;
                  _body = replaceBody();
                })
              })
        });

    //feedMap = await manager.getNamesAndSubMap();
    //feedList = feedMap.values.toList();
  }

  Future<List> getFeedListBool(List feedListBoolVar) async {
    var temp = feedListBoolVar;

    List tempfeedListBool = [];
    print("FEEEDOOOO LISTOOOOOOOOOO");
    print(temp.length);
    print(temp);
    for (int i = 0; i < temp.length; i++) {
      if (temp[i] == "True") {
        tempfeedListBool.add(true);
      }
      if (temp[i] == "False") {
        tempfeedListBool.add(false);
      }
    }
    return tempfeedListBool;
  }
}
