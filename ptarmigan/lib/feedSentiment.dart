class FeedSentiment {
  final int beginDate;
  final int endDate;
  final int intervalData;

  FeedSentiment({
    required this.beginDate,
    required this.endDate,
    required this.intervalData,
  });

  factory FeedSentiment.fromJson(Map<String, dynamic> json) {
    return FeedSentiment(
      beginDate: json['BeginDate'] as int,
      endDate: json['endDate'] as int,
      intervalData: json['intervalData'] as int,
    );
  }
}
