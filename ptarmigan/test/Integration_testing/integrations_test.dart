//@dart=2.9
import 'dart:convert';
import 'dart:io';

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
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

main() {
  Response helperResponse() {
    final mapJson = {
      "Scrape-until": 123421343214.0,
      "scrape-detail": [
        {"content": "Tesla"},
        {"content": "Neuralink"},
        {"content": "Bitcoin"}
      ]
    };

    return Response(json.encode(mapJson), 200);
  }

  back.testWidgets('Widgets are created and populated via API return.',
      (back.WidgetTester tester) async {
    final mapJson = {
      "Scrape-until": 123421343214.0,
      "scrape-detail": [
        {"content": "Tesla"},
        {"content": "Neuralink"},
        {"content": "Bitcoin"}
      ]
    };

    final httpClient = MockClient();

    List<dynamic> temp = ["test1", "test2"];
    when(httpClient.post(any))
        .thenAnswer((_) => Future.value(helperResponse()));
    when(await generator.fetchImages()).thenReturn(temp);
    when(Image.network(any))
        .thenReturn(Image.file(File("assets/images/logo.png")));

    tester.pumpWidget(DashboardScreen());

    back.expect(back.find.byType(Image), back.findsNWidgets(3));
  });
}
