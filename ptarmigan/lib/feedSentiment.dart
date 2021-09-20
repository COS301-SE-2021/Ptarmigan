class FeedSentiment {
  int beginDate;
//  final int endDate;
  String intervalData;

  FeedSentiment({
    required this.beginDate,
    //required this.endDate,
    required this.intervalData,
  });

  factory FeedSentiment.fromJson(Map<String, dynamic> json) {
    return FeedSentiment(
      beginDate: json['TimeStamp'] as int,
      //endDate: json['EndDate'] as int,
      intervalData: json['Sentiment'] as String,
    );
  }
}
