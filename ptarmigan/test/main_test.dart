//@dart=2.9
import 'package:test/test.dart';
import 'package:ptarmigan/main.dart';
import 'package:ptarmigan/models/Feed.dart';
import 'package:ptarmigan/models/Todo.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'main_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart' as back;
import 'package:flutter_test/src/widget_tester.dart';
import 'package:test_api/src/frontend/expect.dart' as front;
import 'package:flutter/material.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FeedChanger>(returnNullOnMissingStub: true),
  MockSpec<Subscriber>(returnNullOnMissingStub: true),
  MockSpec<Feed>(returnNullOnMissingStub: true),
])
void main() {
  test("Test to check for successful insight filtering", () {
    var mockFeedChanger = MockFeedChanger();
    //mockFeedChanger.notifyListeners();
    mockFeedChanger.changeFeed("");

    verify(mockFeedChanger.changeFeed("")).called(1);
  });

  test("Test to check for successful insight filtering", () {
    Subscriber sub = new Subscriber();
    print(sub.subscribe(0));
    int subscribed = 0;
    back.expect(sub.subscribe(subscribed), 1);
  });

  testWidgets("MyWidget has a title and message", (WidgetTester tester) async {
    var childWidget = AppBar();

    await tester.pumpWidget(TodosList());
    // Create the Finders.

    front.expect(back.find.byType(Card), back.findsOneWidget);
  });
}
