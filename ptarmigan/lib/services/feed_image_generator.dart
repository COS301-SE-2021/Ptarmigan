import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:ptarmigan/models/Feed.dart';

class FeedImage {
  final double until;
  final List<dynamic> contents;

  FeedImage({required this.until, required this.contents});

  FeedImage.fromJson(Map<String, dynamic> json)
      : until = json['Scrape-until'],
        contents = json['scrape-detail'];
}

class FeedImageGenerator {
  FeedImageGenerator({this.contents});
  final contents;

  Future<http.Response> fetchFeeds() {
    return http.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"));
  }

  Future<List> fetchImages() async {
    //print("calling api for feed list ");
    final response = await http.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"));

    //print(response.body);
    var res = FeedImage.fromJson(jsonDecode(response.body));
    //if (response.statusCode == 200) {
    //print(res.contents[1]);

    var temp = jsonEncode(res.contents);
    //print("temp : " + temp);

    var finalContents = jsonDecode(temp);
    //print(finalContents[1]);

    for (var i = 0; i < finalContents.length; i++) {
      String hold = finalContents[i].toString();
      hold = hold.substring(10, hold.length - 1);
      hold = hold.trim();
      finalContents[i] = hold;
    }
    //print(finalContents);

    return finalContents;
    // } else {
    //  throw Exception("Failed to fetch images");
    //}
  }
}