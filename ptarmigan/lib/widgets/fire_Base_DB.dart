import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final Firestore _db = Firestore.instance;

  static Future<bool> addTask(Map<String, dynamic> task) async {
    await _db.collection('tasks').document().setData(task).catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<bool> updateTask(String id, Map<String, dynamic> task) async {
    await _db.collection('tasks').document(id).updateData(task).catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<bool> deleteTask(String id) async {
    await _db.collection('tasks').document(id).delete().catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<bool> addSnapShot(Map<String, dynamic> snap) async {
    await _db.collection('snapshots').document().setData(snap).catchError((e) {
      print("Noc");
      print(e);
    });
    return true;
  }

  static Future<bool> updateSnapShot(
      String id, Map<String, dynamic> snap) async {
    await _db
        .collection('snapshots')
        .document(id)
        .updateData(snap)
        .catchError((e) {
      print(e);
    });
    return true;
  }

  static Future<bool> deleteSnapShot(String id) async {
    await _db.collection('snapshots').document(id).delete().catchError((e) {
      print(e);
    });
    return true;
  }
}
