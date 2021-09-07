import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/services/feed_file_manager.dart';

import '../constants.dart';

class FeedSelectorScreen extends StatefulWidget {
  const FeedSelectorScreen();

  @override
  _FeedSelectorScreenState createState() => _FeedSelectorScreenState();
}

class _FeedSelectorScreenState extends State<FeedSelectorScreen> {
  late List feedList;
  late List feedListBool;
  Map feedMap = Map();
  FeedFileManager manager = new FeedFileManager();
  List feedFlag = [];

  bool feedListBoolFlag = false;
  bool feedMapInitialized = false;
  Widget _replaceMentBody = CircularProgressIndicator();
  Widget _body = CircularProgressIndicator();
  @override
  void initState() {
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
    if (feedMapInitialized) {
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
    } else
      return CircularProgressIndicator();
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
                    feedListBool[index] = !feedListBool[index];
                    changeSubscribed(feedList[index]);
                  });
                })
          ],
        )),
        //DataCell(Text(("#"))),
      ],
    );
  }

  void changeSubscribed(String topic) {
    manager.changeSubscribed(topic);
  }

  _initFeedMap() async {
    manager.getNamesAndSubMap().then((value) => {
          setState(() {
            print("Value : $value");
            feedMap = value;
            feedList = value.keys.toList();
          }),
          getFeedListBool(value.values.toList()).then((value) => {
                feedListBool = value,
                _body = replaceBody(),
                feedMapInitialized = true
              })
        });
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
