//@dart=2.9
import 'package:test/test.dart';
import 'package:ptarmigan/main.dart';
import 'package:ptarmigan/models/Todo.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'main_test.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<FeedChanger>(returnNullOnMissingStub: true)])
void main() {
  test("dsadasdas", () {
    var mockFeedChanger = MockFeedChanger();
    mockFeedChanger.notifyListeners();

    verify(mockFeedChanger.notifyListeners()).called(1);
  });
}
