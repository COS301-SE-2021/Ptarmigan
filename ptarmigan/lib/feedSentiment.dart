class FeedSentiment {
  final String beginDate;
  final String endDate;
  final String intervalData;

  FeedSentiment({
    required this.beginDate,
    required this.endDate,
    required this.intervalData,
  });

  factory FeedSentiment.fromJson(Map<String, dynamic> json) {
    return FeedSentiment(
      beginDate: json['beginDate'] as String,
      endDate: json['endDate'] as String,
      intervalData: json['intervalData'] as String,
    );
  }
}
