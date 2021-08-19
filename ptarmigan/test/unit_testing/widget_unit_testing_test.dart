//@dart=2.9
import 'package:amplify_flutter/amplify.dart';
import 'package:provider/provider.dart';
import 'package:ptarmigan/models/ModelProvider.dart';
import 'package:ptarmigan/models/Todo.dart';
import 'package:ptarmigan/services/feed_changer.dart';
import 'package:ptarmigan/services/subscriber.dart';
import 'package:ptarmigan/widgets/add_feed_form.dart';
import 'package:ptarmigan/widgets/add_todo_form.dart';
import 'package:ptarmigan/widgets/feed_items.dart';
import 'package:ptarmigan/widgets/feeds_list.dart';
import 'package:ptarmigan/widgets/feeds_list_admin.dart';
import 'package:ptarmigan/widgets/todo_item.dart';
import 'package:ptarmigan/widgets/todo_list.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:test/test.dart';
import 'package:ptarmigan/main.dart';
import 'package:ptarmigan/models/Feed.dart';
import 'package:ptarmigan/models/Todo.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../main_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart' as back;
import 'package:flutter_test/src/widget_tester.dart';
import 'package:test_api/src/frontend/expect.dart' as front;
import 'package:flutter/material.dart';

class MockBuildContext extends Mock implements BuildContext {}

@GenerateMocks([], customMocks: [
  MockSpec<FeedChanger>(returnNullOnMissingStub: true),
  MockSpec<Subscriber>(returnNullOnMissingStub: true),
  MockSpec<Feed>(returnNullOnMissingStub: true),
])
void main() {
  /*test("Test to check for successful insight filtering", () {
    var mockFeedChanger = MockFeedChanger();
    mockFeedChanger.notifyListeners();
    mockFeedChanger.changeFeed("");

    verify(mockFeedChanger.changeFeed("")).called(1);
  });*/

/*  test("Test to check Subscribe instantiates correctioon", () {
    Subscriber sub = new Subscriber();
    print(sub.subscribe(0));
    int subscribed = 0;
    back.expect(sub.subscribe(subscribed), 1);
  }); */

  /*back.testWidgets('Test that feeds list is correctly displaying',
      (back.WidgetTester tester) async {
    Feed feedOne = new Feed(
        id: "Test1_id",
        feedName: 'Test1_feedname',
        tags: 'Test1_tags',
        description: 'Test1_desc',
        subscribedTo: 0);

    List<Feed> listOfFeeds = [feedOne];

    print('\n======================');
    print(listOfFeeds.toString());
    print('======================\n');

    await tester
        .pumpWidget(MaterialApp(home: FeedsList(feedsSub: listOfFeeds)));

    //tester.drag(back.find.byType(Drawer), const Offset(0, 200));

    //tester.pump();

    front.expect(back.find.text('Test1_feedname'), back.findsOneWidget);
  });*/

  back.testWidgets("Test whether admin list displays correctly",
      (WidgetTester tester) {
    Feed feedOne = new Feed(
        id: "Test1_id",
        feedName: 'Test1_feedname',
        tags: 'Test1_tags',
        description: 'Test1_desc',
        subscribedTo: 1);

    List<Feed> listOfFeeds = [feedOne];

    tester.pumpWidget(MaterialApp(home: FeedsListAdmin(feeds: listOfFeeds)));

    front.expect(back.find.text("Test1_feedname"), back.findsOneWidget);
  });

  /*back.testWidgets("Test whether Todo page displays correctly",
      (WidgetTester tester) async {
    Feed feedOne = new Feed(
        id: "Test1_id",
        feedName: 'Test1_feedname',
        tags: 'Test1_tags',
        description: 'Test1_desc',
        subscribedTo: 1);

    List<Feed> listOfFeeds = [feedOne];

    Todo todoItem = new Todo(
        id: "Test_todo_id",
        name: 'Test_todo_name',
        description: 'Test_todo_desc',
        isComplete: false);

    List<Todo> todoItemList = [todoItem];

    //when(await Amplify.DataStore.query(Feed.classType))
    //  .thenReturn(listOfFeeds);
    // when(await Amplify.DataStore.query(Todo.classType))
    //  .thenReturn(todoItemList);

    tester.pumpWidget(MaterialApp(home: TodosPage()));

    front.expect(back.find.byType(Drawer), back.findsOneWidget);
  });*/

  /*back.testWidgets("Test whether Todo list displays correctly",
      (WidgetTester tester) async {
    //when(Provider.of<FeedChanger>(MockBuildContext()).getFeedChoice)
    // .thenReturn("Test1");

    Todo todoItem = new Todo(
        id: "Test_todo_id",
        name: 'Test_todo_name',
        description: 'Test_todo_desc',
        isComplete: false);

    List<Todo> todoItemList = [todoItem];

    await tester.pumpWidget(MaterialApp(home: TodosList(todos: todoItemList)));
    //tester.pump();

    front.expect(back.find.text("Test_todo_name"), back.findsOneWidget);
  });*/

  back.testWidgets("Test a whether feed item is dipslayed correctly",
      (WidgetTester tester) async {
    Feed feedOne = new Feed(
        id: "Test1_id",
        feedName: 'Test1_feedname',
        tags: 'Test1_tags',
        description: 'Test1_desc',
        subscribedTo: 0);

    await tester.pumpWidget(MaterialApp(home: FeedItems(feed: feedOne)));

    back.expect(back.find.byType(Card), back.findsOneWidget);
  });

  /*back.testWidgets("Test whether a todo item is dipslayed correctly",
      (WidgetTester tester) async {
    Todo todoItem = new Todo(
      id: "Test_todo_id",
      name: 'Test_todo_name',
      description: 'Test_todo_desc',
    );

    await tester.pumpWidget(MaterialApp(home: TodoItem(todo: todoItem)));

    back.expect(back.find.byType(Card), back.findsOneWidget);
  });*/

  back.testWidgets("Test whether the add todo page functions properly",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AddTodoForm()));
    back.expect(back.find.text('Name'), back.findsOneWidget);
    back.expect(back.find.text('Description'), back.findsOneWidget);
    back.expect(back.find.text('Save'), back.findsOneWidget);
  });

  back.testWidgets("Test whether the add feed page functions properly",
      (WidgetTester tester) async {
    Feed feedOne = new Feed(
        id: "Test1_id",
        feedName: 'Test1_feedname',
        tags: 'Test1_tags',
        description: 'Test1_desc',
        subscribedTo: 0);

    Feed feedTwo = new Feed(
        id: "Test2_id",
        feedName: 'Test2_feedname',
        tags: 'Test2_tags',
        description: 'Test2_desc',
        subscribedTo: 0);

    List<Feed> feedList = [feedOne, feedTwo];

    await tester.pumpWidget(MaterialApp(home: AddFeedForm(feeds: feedList)));
    back.expect(back.find.text('Test1_feedname'), back.findsOneWidget);
    back.expect(back.find.text('Test2_feedname'), back.findsOneWidget);
  });
}
