//@dart=2.9
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as back;
import 'package:flutter_test/src/widget_tester.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:ptarmigan/services/feed_image_generator.dart';
import 'package:ptarmigan/widgets/home_page.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import 'package:test_api/src/frontend/expect.dart' as front;

import 'package:http/http.dart' show Response;

main() {
  back.test('Insuring Stock API call works', () async {
    FeedImageGenerator generator = FeedImageGenerator();
    generator.client = MockClient((request) async {
      final mapJson = {
        "Scrape-until": 123421343214.0,
        "scrape-detail": [
          {"content": "Tesla"},
          {"content": "Neuralink"},
          {"content": "Bitcoin"}
        ]
      };
      return Response(json.encode(mapJson), 200);
    });
    final item = await generator.fetchImages();
    back.expect(item[0], "Tesla");
  });
}
