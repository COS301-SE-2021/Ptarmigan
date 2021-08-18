class SentimentHistoryItem {
  String? icon, title, date, size;

  SentimentHistoryItem({this.icon, this.title, this.date, this.size});
}

List demoRecentFiles = [
  SentimentHistoryItem(
    icon: "assets/icons/Medium.svg",
    title: "01-03-2021",
    date: "62%",
    size: "3.5mb",
  ),
  SentimentHistoryItem(
    icon: "assets/icons/Negative.svg",
    title: "01-03-2021",
    date: "30%",
    size: "19.0mb",
  ),
];
