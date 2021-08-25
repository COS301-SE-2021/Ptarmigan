import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' show Client;
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
  Client client = Client();

  Future<List> fetchImages() async {
    print("calling api for feed list ");
    final response = await client.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"));

    //print(response.body);
    if (response.statusCode != 200) {
      throw Exception("BucketList API is not responding/ API Timed out");
      return ["N/A"];
    }
    var res = FeedImage.fromJson(jsonDecode(response.body));
    //if (response.statusCode == 200) {
    //print(res.contents[1]);

    var temp = jsonEncode(res.contents);
    print("temp : " + temp);

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
