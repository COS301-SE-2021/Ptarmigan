import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptarmigan/widgets/newsEntity.dart';
import 'fire_base_DB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'snapShot.dart';
import '../constants.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import '../models/NewsArticle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(App());

String emailOfUser = "";
List<NewsEntity> todosGraph = [];

List<String> titleIn = [];
List<String> descriptionIn = [];
List<String> urlIn = [];
List<String> urlToImageIn = [];
List<String> contentIn = [];

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Explore', home: Explore());
  }
}

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        backgroundColor: bgColor,
      ),
      body: _getSnapshots(),
    );
  }

  // Display Add Task Dialog

  //FetchNews

  Future<String> fetchNews() async {
    try {
      print("NEWS NEWS NEWS NEWS");
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      final response2 = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/everything?q=tesla&from=2021-09-27&to=2021-09-27&sortBy=popularity&apiKey=4c093685afb34168b82c1ad34638b093'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response2.statusCode == 200) {
        print(response2.body);
        Map<String, dynamic> maps = jsonDecode(response2
            .body /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        print("NEWS");
        print(maps);

        List<dynamic> data = maps["articles"];

        print(maps["articles"]);

        print("BINGO");
        print(data[0]["title"]);

        titleIn.add(data[0]["title"]);
        descriptionIn.add(data[0]["description"]);
        urlIn.add(data[0]["url"]);
        urlToImageIn.add(data[0]["urlToImage"]);
        contentIn.add(data[0]["content"]);

        print(data);
        //  List<NewsArticles> test1 =
        //     List<NewsArticles>.from(data.map((i) => NewsArticles.fromJson(i)));

        print("Trasque");

        print(titleIn);

        // print(test1);

        //  todosGraph[0] = new NewsEntity(title: data["title"], description: description, url: url, urlToImage: urlToImage, content: content))
        /*  for (int i = 0; i < test1.length; i++) {
          todosGraph[i] = new NewsEntity(
              title: test1[i].title.toString(),
              description: test1[i].description.toString(),
              url: test1[i].url.toString(),
              urlToImage: test1[i].urlToImage.toString(),
              content: test1[i].content.toString());
        } */
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        print(response2.statusCode);
        throw Exception('Failed to create post.');
      }
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }

    //Second

    try {
      print("NEWS NEWS NEWS NEWS");
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      final response2 = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/everything?q=apple&from=2021-09-27&to=2021-09-27&sortBy=popularity&apiKey=4c093685afb34168b82c1ad34638b093'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response2.statusCode == 200) {
        print(response2.body);
        Map<String, dynamic> maps = jsonDecode(response2
            .body /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        print("NEWS");
        print(maps);

        List<dynamic> data = maps["articles"];

        print(maps["articles"]);

        print("BING");
        print(data[0]["title"]);

        titleIn.add(data[0]["title"]);
        descriptionIn.add(data[0]["description"]);
        urlIn.add(data[0]["url"]);
        urlToImageIn.add(data[0]["urlToImage"]);
        contentIn.add(data[0]["content"]);
        print(data);
        //  List<NewsArticles> test1 =
        //     List<NewsArticles>.from(data.map((i) => NewsArticles.fromJson(i)));

        print("Trasque");

        print(titleIn);

        // print(test1);

        //  todosGraph[0] = new NewsEntity(title: data["title"], description: description, url: url, urlToImage: urlToImage, content: content))
        /*  for (int i = 0; i < test1.length; i++) {
          todosGraph[i] = new NewsEntity(
              title: test1[i].title.toString(),
              description: test1[i].description.toString(),
              url: test1[i].url.toString(),
              urlToImage: test1[i].urlToImage.toString(),
              content: test1[i].content.toString());
        } */
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        print(response2.statusCode);
        throw Exception('Failed to create post.');
      }
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }

    //Third

    try {
      print("NEWS NEWS NEWS NEWS");
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      final response2 = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/everything?q=bitcoin&from=2021-09-27&to=2021-09-27&sortBy=popularity&apiKey=4c093685afb34168b82c1ad34638b093'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response2.statusCode == 200) {
        print(response2.body);
        Map<String, dynamic> maps = jsonDecode(response2
            .body /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        print("NEWS");
        print(maps);

        List<dynamic> data = maps["articles"];

        print(maps["articles"]);

        print("BING");
        print(data[0]["title"]);

        titleIn.add(data[0]["title"]);
        descriptionIn.add(data[0]["description"]);
        urlIn.add(data[0]["url"]);
        urlToImageIn.add(data[0]["urlToImage"]);
        contentIn.add(data[0]["content"]);

        print(data);
        //  List<NewsArticles> test1 =
        //     List<NewsArticles>.from(data.map((i) => NewsArticles.fromJson(i)));

        print("Trasque");

        print(titleIn);

        // print(test1);

        //  todosGraph[0] = new NewsEntity(title: data["title"], description: description, url: url, urlToImage: urlToImage, content: content))
        /*  for (int i = 0; i < test1.length; i++) {
          todosGraph[i] = new NewsEntity(
              title: test1[i].title.toString(),
              description: test1[i].description.toString(),
              url: test1[i].url.toString(),
              urlToImage: test1[i].urlToImage.toString(),
              content: test1[i].content.toString());
        } */
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.

        print(response2.statusCode);
        throw Exception('Failed to create post.');
      }
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }

    //Fourth

    try {
      print("NEWS NEWS NEWS NEWS");
      //  Amplify.DataStore.clear();
      //  Delete();
      //demoRecentFiles = [];
      // String a =
      //     '[{"BeginDate": 1623005418000, "EndDate": 1623610218000, "IntervalData": 0}, {"BeginDate": 1623610218000, "EndDate": 1624215018000, "IntervalData": 0}, {"BeginDate": 1624215018000, "EndDate": 1624819818000, "IntervalData": 0}, {"BeginDate": 1624819818000, "EndDate": 1625424618000, "IntervalData": 0}, {"BeginDate": 1625424618000, "EndDate": 1626029418000, "IntervalData": 0}, {"BeginDate": 1626029418000, "EndDate": 1626634218000, "IntervalData": 0}, {"BeginDate": 1626634218000, "EndDate": 1627239018000, "IntervalData": 0}, {"BeginDate": 1627239018000, "EndDate": 1627843818000, "IntervalData": 0}, {"BeginDate": 1627843818000, "EndDate": 1628448618000, "IntervalData": 0.06540074664700189}, {"BeginDate": 1628448618000, "EndDate": 1629053418000, "IntervalData": 0}]';
      // final parsed = jsonDecode(a).cast<Map<String, dynamic>>();

      final response2 = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/everything?q=disney&from=2021-09-27&to=2021-09-27&sortBy=popularity&apiKey=4c093685afb34168b82c1ad34638b093'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response2.statusCode == 200) {
        print(response2.body);
        Map<String, dynamic> maps = jsonDecode(response2
            .body /* .substring(response2.body.indexOf("["), response2.body.length - 1)*/);

        print("NEWS");
        print(maps);

        List<dynamic> data = maps["articles"];

        print(maps["articles"]);

        print("BING");
        print(data[0]["title"]);

        titleIn.add(data[0]["title"]);
        descriptionIn.add(data[0]["description"]);
        urlIn.add(data[0]["url"]);
        urlToImageIn.add(data[0]["urlToImage"]);
        contentIn.add(data[0]["content"]);

        print(data);
        //  List<NewsArticles> test1 =
        //     List<NewsArticles>.from(data.map((i) => NewsArticles.fromJson(i)));

        print("Trasque");

        print(titleIn);

        // print(test1);

        //  todosGraph[0] = new NewsEntity(title: data["title"], description: description, url: url, urlToImage: urlToImage, content: content))
        /*  for (int i = 0; i < test1.length; i++) {
          todosGraph[i] = new NewsEntity(
              title: test1[i].title.toString(),
              description: test1[i].description.toString(),
              url: test1[i].url.toString(),
              urlToImage: test1[i].urlToImage.toString(),
              content: test1[i].content.toString());
        } */
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
    return "Done";
  }

  void _handleSnapshotSubmission(
      String title, String value, String sent, String stoc) {
    var task = <String, dynamic>{
      'stocktitle': title,
      'content': value,
      'sentiment': sent,
      'stock': stoc,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };
    Database.addSnapShot(task);
  }

  // Add Task
  void _handleDialogSubmission(String value) {
    var task = <String, dynamic>{
      'content': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };
    Database.addTask(task);
  }

  // Placeholder Function to retrieve Tasks

  void _updateTask(String updatedValue, String id) {
    var task = <String, dynamic>{
      'content': updatedValue,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    };
    Database.updateTask(id, task);
  }

  void _deleteTask(String id) {
    Database.deleteTask(id);
  }

  void _deleteSnapshot(String id) {
    Database.deleteSnapShot(id);
  }

  void _getUser() async {
    AuthUser a = await AmplifyAuthCognito().getCurrentUser();

    emailOfUser = a.username;
  }

  Widget _getSnapshots() {
    _getUser();
    //  fetchNews("Tesla");

    return FutureBuilder(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            return Container(
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView(children: [
                Card(
                    color: secondaryColor,
                    child: Column(children: [
                      Text("Popular News", style: TextStyle(fontSize: 30)),
                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 30),
                          child: Text(
                            "Take a look at the most popular news articles on some of the top companies.",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ))
                    ])),
                Card(
                    color: bgColor,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 10, 220, 1),
                        child: Text(
                          "Tesla",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Text(titleIn[0],
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Image.network(urlToImageIn[0])),
                      Container(
                          padding: EdgeInsets.fromLTRB(1, 1, 200, 1),
                          child: ElevatedButton(
                              onPressed: () => _launchURL(urlIn[2]),
                              child: Text(
                                "Visit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber)))
                    ])),
                Card(
                    color: bgColor,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 10, 220, 1),
                        child: Text(
                          "Apple",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Text(titleIn[1],
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Image.network(urlToImageIn[1])),
                      Container(
                          padding: EdgeInsets.fromLTRB(1, 1, 200, 1),
                          child: ElevatedButton(
                              onPressed: () => _launchURL(urlIn[2]),
                              child: Text(
                                "Visit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber)))
                    ])),
                Card(
                    color: bgColor,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 10, 220, 1),
                        child: Text(
                          "Bitcoin",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Text(titleIn[2],
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Image.network(urlToImageIn[2])),
                      Container(
                          padding: EdgeInsets.fromLTRB(1, 1, 200, 1),
                          child: ElevatedButton(
                              onPressed: () => _launchURL(urlIn[2]),
                              child: Text(
                                "Visit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber)))
                    ])),
                Card(
                    color: bgColor,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(2, 10, 220, 1),
                        child: Text(
                          "Disney",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 150,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Text(titleIn[3],
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                      Divider(
                        height: 20,
                        thickness: 3,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Image.network(urlToImageIn[3])),
                      Container(
                          padding: EdgeInsets.fromLTRB(1, 1, 200, 1),
                          child: ElevatedButton(
                              onPressed: () => _launchURL(urlIn[3]),
                              child: Text(
                                "Visit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber)))
                    ]))
              ]),
            );
          } else {
            return Container();
          }
        });
  }
}

DataRow recentFileDataRow(NewsEntity fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.description)),
      // DataCell(Text(fileInfo.size)),
    ],
  );
}

_launchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
