import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:ptarmigan/models/Feed.dart';

class FeedImage {
  final double until;
  final List<dynamic> contents;

  FeedImage({required this.until, required this.contents});

  factory FeedImage.fromJson(Map<String, dynamic> json) {
    return FeedImage(
        until: json['Scrape-until'], contents: json['scrape-detail']);
  }

  void printContents() {
    print(contents);
  }
}

class FeedImageGenerator {
  FeedImageGenerator();

  Future<http.Response> fetchFeeds() {
    return http.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"));
  }

  Future<FeedImage> fetchImages() async {
    final response = await http.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"));

    //if (response.statusCode == 200) {
    return FeedImage.fromJson(jsonDecode(response.body));
    // } else {
    //  throw Exception("Failed to fetch images");
    //}
  }
}
