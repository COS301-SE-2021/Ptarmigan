import 'package:flutter/material.dart';
import 'fire_base_DB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'snapShot.dart';
import '../constants.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

void main() => runApp(App());

String emailOfUser = "";

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Snapshot Inbox', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snapshot Inbox'),
        backgroundColor: bgColor,
      ),
      body: _getSnapshots(),
    );
  }

  // Display Add Task Dialog

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
            print(snapshot.data!.documents.length);
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) => SnapShot(
                  time:
                      (snapshot.data!.documents[index]['timestamp']).toString(),
                  stockTitle: snapshot.data!.documents[index]['stocktitle'],
                  to: snapshot.data!.documents[index]['to'],
                  from: snapshot.data!.documents[index]['from'],
                  content: snapshot.data!.documents[index]['content'],
                  sentiment: snapshot.data!.documents[index]['sentiment']
                      .substring(0, 3),
                  stockPrice: snapshot.data!.documents[index]['stock'],
                  id: snapshot.data!.documents[index].documentID,
                  update: _updateTask,
                  delete: _deleteSnapshot),
              itemCount: snapshot.data!.documents.length,
            );
          } else {
            return Container();
          }
        });
  }
}
