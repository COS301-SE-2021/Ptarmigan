import 'dart:convert';

import 'package:flutter/material.dart';
import 'fire_base_DB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'snapShot.dart';
import '../constants.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import '../models/NewsArticle.dart';

void main() => runApp(App());

String emailOfUser = "";

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

  Future<void> fetchNews(var feedIdentifier) async {
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
        print(maps[0]);

        List<dynamic> data = maps["articles"];

        List<NewsArticles> test1 =
            List<NewsArticles>.from(data.map((i) => NewsArticles.fromJson(i)));
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
    fetchNews("Tesla");

    String email = emailOfUser;
    print("RINGGER: " + email);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('snapshots')
            .where('to', isEqualTo: email)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) => NewsArticles(
                title:
                    (snapshot.data!.documents[index]['timestamp']).toString(),
                description: snapshot.data!.documents[index]['stocktitle'],
                url: snapshot.data!.documents[index]['to'],
                from: snapshot.data!.documents[index]['from'],
                urlToImage: snapshot.data!.documents[index]['content'],
                sentiment: snapshot.data!.documents[index]['sentiment'],
                content: snapshot.data!.documents[index]['stock'],
                id: snapshot.data!.documents[index].documentID,
              ),
              itemCount: snapshot.data!.documents.length,
            );
          } else {
            return Container();
          }
        });
  }
}
