import 'package:bezier_chart/bezier_chart.dart';

class StockHistoryItem {
  String? icon, title, date, size;

  StockHistoryItem({this.icon, this.title, this.date, this.size});
}

List demoRecentFiles2 = [];
List<DataPoint<dynamic>> demoList = [];

String currentSentiment = "";
String currentStock = "";
