//@dart=2.9
import 'package:test/test.dart';
import 'package:ptarmigan/main.dart';
import 'package:ptarmigan/models/Feed.dart';
import 'package:ptarmigan/models/Todo.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'main_test.mocks.dart';

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
    expect(sub.subscribe(subscribed), 1);
  });
}
