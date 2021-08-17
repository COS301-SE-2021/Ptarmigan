//@dart=2.9
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as back;
import 'package:flutter_test/src/widget_tester.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:ptarmigan/services/feed_image_generator.dart';
import 'package:ptarmigan/services/stock_price_generator.dart';
import 'package:ptarmigan/widgets/home_page.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import 'package:test_api/src/frontend/expect.dart' as front;
import 'package:test/test.dart';

const fakeResponse = {
  "bitcoin": "123",
  "tesla": "111111",
};

void main() {
  back.setUp(() {});

  /*back.testWidgets("Test a whether feed item is dipslayed correctly",
      (WidgetTester tester) async {
    Feed feedOne = new Feed(
        id: "Test1_id",
        feedName: 'Test1_feedname',
        tags: 'Test1_tags',
        description: 'Test1_desc',
        subscribedTo: 0);

    await tester.pumpWidget(MaterialApp(home: FeedItems(feed: feedOne)));

    back.expect(back.find.byType(Card), back.findsOneWidget);
  });*/

  back.test('Insuring Stock API call works with multiple objects', () async {
    StockPriceGenerator generator = StockPriceGenerator();
    generator.client = MockClient((request) async {
      final mapJson = {"bitcoin": 420.69, "tesla": 666.8};

      return Response(json.encode(mapJson), 200,
          headers: {'content-type': 'application/json'});
    });
    final item = await generator.fetchPrices();
    back.expect(item['tesla'], 666.8);
  });

  back.test('Insuring Stock API call works', () async {
    StockPriceGenerator generator = StockPriceGenerator();
    generator.client = MockClient((request) async {
      return Response(json.encode({'bitcoin': 420.69}), 200,
          headers: {'content-type': 'application/json'});
    });
    final item = await generator.fetchPrices();
    back.expect(item['bitcoin'], 420.69);
  });

  back.test('In event of API failure, exception is thrown and caught.',
      () async {
    StockPriceGenerator generator = StockPriceGenerator();
    generator.client = MockClient((request) async {
      final mapJson = {"message": "Internal server error"};
      return Response(json.encode(mapJson), 502);
    });
    var message;
    try {
      final item = await generator.fetchPrices();
    } on Exception catch (e) {
      message = e.toString();
    }
    back.expect(message, "Exception: API is not responding/ API Timed out");
  });
}
