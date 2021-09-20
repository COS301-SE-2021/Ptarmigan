class FeedStock {
  int beginDate;
//  final int endDate;
  final String stockData;

  FeedStock({
    required this.beginDate,
    //required this.endDate,
    required this.stockData,
  });

  factory FeedStock.fromJson(Map<String, dynamic> json) {
    return FeedStock(
      beginDate: json['TimeStamp'] as int,
      //endDate: json['EndDate'] as int,
      stockData: json['Stock'] as String,
    );
  }
}
