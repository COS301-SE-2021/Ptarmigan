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
  late List fullFeedList;
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
    int len = feedList.length;
    print("Feed list lenght = $len");
    print("replaceBody called.");
    //print(feedListBool);
    return Container(
        child: Column(children: [
      SizedBox(height: defaultPadding),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 50,
            child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Search..."),
                onChanged: (text) {
                  updateFeedList(text);
                  setState(() {
                    _body = replaceBody();
                  });
                }),
          )
        ],
      ),
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: bgColor,
            height: 400,
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
          ))
    ]));
  }

  DataRow recentFileDataRow(int index) {
    print("Index :$index");
    print(feedList);
    if (feedList.isEmpty)
      return DataRow(
          cells: [DataCell(Text("No results found")), DataCell((Text("")))]);
    else if (feedList.length == 1) {
      if (index == 0)
        return DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
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
      else
        return DataRow(
          cells: [
            DataCell(
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(""),
                  ),
                ],
              ),
            ),
            DataCell(Row(
              children: [
                Text(""),
              ],
            )),
            //DataCell(Text(("#"))),
          ],
        );
    } else
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
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

  Future<void> changeSubscribed(String topic) async {
    print("Change subscribed on $topic called");
    manager.changeSubscribed(topic);
    feedMap = await manager.getNamesAndSubMap();
  }

  _initFeedMap() async {
    manager.getNamesAndSubMap().then((value) => {
          setState(() {
            print("GetNamesAndSubMap called in setState");
            print("Value : $value");
            feedMap = value;
            feedList = value.keys.toList();
            fullFeedList = feedList;
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

  List<bool> getCurrentFeedBools(List feedBools) {
    if (feedBools.isNotEmpty) {
      List<bool> tempList = [];
      for (var i = 0; i < feedBools.length; i++) {
        if (feedMap.containsKey(feedBools[i])) if (feedMap[feedBools[i]] ==
            "False")
          tempList.add(false);
        else if (feedMap[feedBools[i]] == "True") tempList.add(true);
      }
      return tempList;
    } else
      return [];
  }

  void updateFeedList(String topic) {
    feedList = searchFeedList(topic);
    feedListBool = getCurrentFeedBools(feedList);
    _body = replaceBody();
  }

  List searchFeedList(String topic) {
    print("Sorting topic : $topic");
    if (topic.isEmpty) {
      getFeedListBool(feedMap.values.toList())
          .then((value) => feedListBool = value);
      return fullFeedList;
    } else {
      List tempBoolList = [];
      List tempFeedList = [];
      for (var i = 0; i < fullFeedList.length; i++) {
        String feedHolder = fullFeedList[i];
        feedHolder = feedHolder.toLowerCase();
        topic = topic.toLowerCase();
        if (feedHolder.contains(topic.trim())) {
          tempFeedList.add(fullFeedList[i]);
        }
      }
      print("Updated feed list = $tempFeedList");
      return tempFeedList;
    }
  }
}
