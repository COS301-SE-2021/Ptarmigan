import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' show Client;
import 'package:ptarmigan/models/Feed.dart';

class TweetJson {
  final String tweetID;
  final String tweetWeight;

  TweetJson({required this.tweetID, required this.tweetWeight});

  TweetJson.fromJson(Map<String, dynamic> json)
      : tweetID = json['Tweet_Id'],
        tweetWeight = json['Weight'];
}

class PopularTweetGenerator {
  PopularTweetGenerator({this.contents});
  final contents;
  Client client = Client();

  Future<TweetJson> fetchTweet(String stock) async {
    print("Calling Tweet generator.");

    //print("calling api for feed list ");
    final response = await client.post(
      Uri.parse(
          "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/senthisize/getMostPopularTweet"),
      body: (jsonEncode(<String, dynamic>{
        "BeginDate": 1628564655,
        "EndDate": 1628659505,
        "CompanyName": stock
      })),
    );
    print("Finished API call");
    //print(response.body);
    if (response.statusCode != 200) {
      throw Exception("API is not responding/ API Timed out");
      //return ["N/A"];
    }
    var res = TweetJson.fromJson(jsonDecode(response.body));
    //if (response.statusCode == 200) {
    //print(res.contents[1]);

    print(res.tweetID);
    //print("temp : " + temp);

    //print(finalContents[1]);

    // } else {
    //  throw Exception("Failed to fetch images");
    //}
    //print(response.body);
    return res;
  }

  Future<String> generateTwitterPageID(List<dynamic> feedImages) async {
    List<String> IDs = [];
    List<int> weights = [];
    int highestWeight = -1;
    String highestID = "null";
    for (int i = 0; i < feedImages.length; i++) {
      var temp = await fetchTweet(feedImages[i]);
      var tempWeight = int.parse(temp.tweetWeight);
      print("Stock : " + feedImages[i] + "  WEIGHT : " + tempWeight.toString());
      weights.add(tempWeight);
      IDs.add(temp.tweetID);

      if (highestWeight < tempWeight) {
        highestWeight = tempWeight;
        highestID = temp.tweetID;
      }
    }

    if (highestID == "null" || highestID == null)
      throw Exception("Stock list provided is empty");
    else
      return highestID;
  }
}
