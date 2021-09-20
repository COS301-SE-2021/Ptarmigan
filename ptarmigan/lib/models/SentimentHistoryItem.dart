import 'package:bezier_chart/bezier_chart.dart';

class SentimentHistoryItem {
  String? icon, title, date, size;

  SentimentHistoryItem({this.icon, this.title, this.date, this.size});
}

List demoRecentFiles = [];
List<DataPoint<dynamic>> demoList = [];

String currentSentiment = "";
String currentStock = "";
