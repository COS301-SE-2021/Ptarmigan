import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client;

import 'package:http/http.dart';
import 'package:ptarmigan/models/Feed.dart';

class StockPrices {
  final double code;
  final List<dynamic> body;

  StockPrices({required this.code, required this.body});

  StockPrices.fromJson(Map<String, dynamic> json)
      : code = json['statusCode'],
        body = json['body'];
}

class StockPriceGenerator {
  final contents;
  Client client = Client();
  StockPriceGenerator({this.contents});

  Future<Map> fetchPrices() async {
    print("Attempting to access Stock API");
    //print("calling api for feed list ");
    final response = await client.post(Uri.parse(
        "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/stocks/returnStockPriceList"));

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
