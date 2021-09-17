import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client;

import 'package:http/http.dart';

class SentimentPrediction {
  final double code;
  final List<dynamic> body;

  SentimentPrediction({required this.code, required this.body});

  SentimentPrediction.fromJson(Map<String, dynamic> json)
      : code = json['statusCode'],
        body = json['body'];
}

class SentimentPredictionGenerator {
  final contents;
  Client client = Client();
  SentimentPredictionGenerator({this.contents});

  Future<Map> fetchPrediction() async {
    print("Attempting to access Prediction API");
    //print("calling api for feed list ");
    final response = await client.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/stocks/returnStockPriceList")); //Replace url with prediction endpoint

    if (response.statusCode != 200) {
      throw Exception("Prediction API is not responding/ API Timed out");
    }

    print(response.body);
    var code = response.statusCode;
    print(code);
    Map<String, dynamic> res = jsonDecode(response.body);
    //if (response.statusCode == 200) {
    //print(res['Bitcoin']);

    //print("temp : " + temp);

    //print(finalContents[1]);

    /* for (var i = 0; i < finalContents.length; i++) {
      String hold = finalContents[i].toString();
      hold = hold.substring(10, hold.length - 1);
      hold = hold.trim();
      finalContents[i] = hold;
    }*/
    //print(finalContents);

    return res;
    // } else {
    //  throw Exception("Failed to fetch images");
    //}
  }
}
