import 'package:flutter/material.dart';
import 'fire_base_DB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'snapShot.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To-Do List', home: TodoList());
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
      appBar: AppBar(title: Text('To-Do List')),
      body: _getSnapshots(),
    );
  }

  // Display Add Task Dialog

  void _handleSnapshotSubmission(String value, String sent, String stoc) {
    var task = <String, dynamic>{
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

  Widget _getSnapshots() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('snapshots')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) => SnapShot(
                  to: snapshot.data!.documents[index]['to'],
                  from: snapshot.data!.documents[index]['from'],
                  content: snapshot.data!.documents[index]['content'],
                  sentiment: snapshot.data!.documents[index]['sentiment'],
                  stockPrice: snapshot.data!.documents[index]['stock'],
                  id: snapshot.data!.documents[index].documentID,
                  update: _updateTask,
                  delete: _deleteTask),
              itemCount: snapshot.data!.documents.length,
            );
          } else {
            return Container();
          }
        });
  }
}
