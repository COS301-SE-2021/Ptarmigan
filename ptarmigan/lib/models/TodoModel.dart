import 'package:amplify_datastore/amplify_datastore.dart';

class TodoModel {
  final String name;
  final String description;
  final TemporalDate date;

  TodoModel({
    required this.name,
    required this.description,
    required this.date,
  });
}
