class FeedStockSentiment {
  final String stock;
//  final int endDate;
  final String sentiment;

  FeedStockSentiment({
    required this.stock,
    //required this.endDate,
    required this.sentiment,
  });

  factory FeedStockSentiment.fromJson(Map<String, dynamic> json) {
    return FeedStockSentiment(
      stock: json['Stock'] as String,
      //endDate: json['EndDate'] as int,
      sentiment: json['Sentiment'] as String,
    );
  }
}
