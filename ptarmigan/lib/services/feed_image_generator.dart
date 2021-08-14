import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:ptarmigan/models/Feed.dart';

class FeedImageGenerator {
  FeedImageGenerator();

  Future<http.Response> fetchFeeds() {
    return http.get(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"));
  }

  
}

class FeedImage {
  final String until;
  final List<String> contents;

  FeedImage({
    required this.until,
    required this.contents
  })

  // ignore: empty_constructor_bodies
  factory FeedImage.fromJson(Map<String, dynamic> json)
  {
    return FeedImage(
    until: json['Scrape-until'],
    contents: json['scrape-detail']);
    
  }
  
}
