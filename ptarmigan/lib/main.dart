// @dart=2.9
// dart async library we will refer to when setting up real time updates
import 'dart:async';
// flutter and ui libraries
import 'package:amplify_auth_cognito/method_channel_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// amplify packages we will need to use
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';
import 'auth/login/login_screen.dart';
import 'models/ModelProvider.dart';
import 'models/Todo.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

final ValueNotifier feedID = ValueNotifier("");
List<Todo> todos;
List<Feed> _feeds;
void main() {
  runApp(MyApp());
}

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: FeedChanger(),
          ),
        ],
        child: MaterialApp(
          title: 'Amplified Todo',
          home: TodosPage(),
          //home: Login(),
        ));
  }
}

class TodosPage extends StatefulWidget {
  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  bool _isLoading;
  bool isSignUpComplete;
  StreamSubscription _subscription;
  StreamSubscription _subscriptionFeed;

  List<Todo> _todos;

  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);

  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

  @override
  void initState() {
    _isLoading = true;
    _todos = [];
    _feeds = [];
    _initializeApp();
    super.initState();
  }

  @override
  void dispose() {
    // cancel the subscription when the state is removed from the tree
    _subscription.cancel();
    _subscriptionFeed.cancel();

    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    await _configureAmplify();

    // listen for updates to Todo entries by passing the Todo classType to
    // Amplify.DataStore.observe() and when an update event occurs, fetch the
    // todo list
    //
    // note this strategy may not scale well with larger number of entries
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      _fetchTodos();
    });

    _subscriptionFeed =
        Amplify.DataStore.observe(Feed.classType).listen((event) {
      _fetchFeeds();
    });

    // fetch Todo entries from DataStore
    await _fetchTodos();
    await _fetchFeeds();
    // after both configuring Amplify and fetching Todo entries, update loading
    // ui state to loaded state
    setState(() {
      _isLoading = false;
    });
  }

  //---------------------------------------------------------------------
  //Beginning of signing in flow

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      //await Amplify.addPlugins([_dataStorePlugin]);

      await Amplify.addPlugins([
        _dataStorePlugin,
        _apiPlugin,
        _authPlugin,
      ]);
      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
    }
  }

  Future<void> _fetchTodos() async {
    try {
      // query for all Todo entries by passing the Todo classType to
      // Amplify.DataStore.query()
      List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType);

      // update the ui state to reflect fetched todos
      setState(() {
        _todos = updatedTodos;
      });
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }
  }

  Future<void> _fetchFeeds() async {
    try {
      // query for all Todo entries by passing the Todo classType to
      // Amplify.DataStore.query()
      List<Feed> updatedFeed = await Amplify.DataStore.query(Feed.classType);

      // update the ui state to reflect fetched todos
      setState(() {
        _feeds = updatedFeed;
      });
    } catch (e) {
      print('An error occurred while querying Feeds: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeds'),
        backgroundColor: Colors.teal,
      ),
      //body: Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TodosList(todos: _todos),
      drawer: FeedsList(feeds: _feeds),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoForm()),
          );
        },
        tooltip: 'Add insight',
        label: Row(
          children: [Icon(Icons.add), Text('Add insight')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class TodosList extends StatelessWidget {
  List<Todo> todos;
  final List<Feed> feeds;
  StreamSubscription _subscription;
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TodosList({this.todos, this.feeds});

  bocko(var feedChoice) async {
    _subscription = Amplify.DataStore.observe(Todo.classType).listen((event) {
      fetchNewTodos(feedChoice);
    });

    await fetchNewTodos(feedChoice);
  }

  Future<void> fetchNewTodos(var feedIdentifier) async {
    print("KONO: " + feedIdentifier);
    List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType,
        where: Todo.NAME.eq(feedIdentifier));
    todos = updatedTodos;
    print("VACO: " + todos.elementAt(0).name);
  }

  @override
  Widget build(BuildContext context) {
    var feedChoice = Provider.of<FeedChanger>(context).getFeedChoice;

    bocko(feedChoice);
    print("ORO: " + todos.elementAt(0).name);

    return Scaffold(
        key: scaffoldKey,
        body: Container(
          width: double.infinity,
          height: 500,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: PageView(
                  controller: pageViewController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    todos.length >= 1
                        ? ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            children: todos
                                .map((todo) => TodoItem(todo: todo))
                                .toList())
                        : Center(
                            child: Text('Tap button below to add a todo!')),
                    ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      children: [],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(0, 1),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: SmoothPageIndicator(
                    controller: pageViewController,
                    count: 2,
                    axisDirection: Axis.horizontal,
                    onDotClicked: (i) {
                      pageViewController.animateToPage(
                        i,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    effect: ExpandingDotsEffect(
                      expansionFactor: 2,
                      spacing: 8,
                      radius: 16,
                      dotWidth: 16,
                      dotHeight: 16,
                      dotColor: Color(0xFF9E9E9E),
                      activeDotColor: Colors.teal,
                      paintStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class FeedChanger extends ChangeNotifier {
  var _feedChoice = "";

  String get getFeedChoice {
    return _feedChoice;
  }

  void changeFeed(String a) {
    _feedChoice = a;

    notifyListeners();
  }
}

class TodoItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Todo todo;

  TodoItem({this.todo});

  void _deleteTodo(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(todo);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  Future<void> _toggleIsComplete() async {
    // copy the Todo we wish to update, but with updated properties
    Todo updatedTodo = todo.copyWith(isComplete: !todo.isComplete);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _toggleIsComplete();
        },
        onLongPress: () {
          _deleteTodo(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(todo.description ?? 'No description'),
                ],
              ),
            ),
            Icon(
                todo.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
    );
  }
}

class AddTodoForm extends StatefulWidget {
  @override
  _AddTodoFormState createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _saveTodo() async {
    // get the current text field contents
    String name = _nameController.text;
    String description = _descriptionController.text;

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    Todo newTodo = Todo(
        name: name,
        description: description.isNotEmpty ? description : null,
        isComplete: false);

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newTodo);
      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Feed'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(filled: true, labelText: 'Name')),
              TextFormField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(filled: true, labelText: 'Description')),
              ElevatedButton(onPressed: _saveTodo, child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}

//Feeds===============================================================

class FeedItems extends StatelessWidget {
  final double iconSize = 24.0;
  final Feed feed;

  FeedItems({this.feed});

  void _deleteFeed(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(feed);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    void _changeFeed() {
      Provider.of<FeedChanger>(context, listen: false)
          .changeFeed(feed.feedName);
    }

    ;

    return Card(
      child: InkWell(
        onLongPress: () {
          _deleteFeed(context);
        },
        onTap: () {
          // update the ui state to reflect fetched todos
          // feedID.value = feed.feedName;
          _changeFeed();

          //print(feedID.value);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feed.feedName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(feed.description ?? 'No description'),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class AddFeedForm extends StatefulWidget {
  @override
  _AddFeedFormState createState() => _AddFeedFormState();
}

class _AddFeedFormState extends State<AddFeedForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  Future<void> _saveFeed() async {
    // get the current text field contents
    String name = _nameController.text;
    String description = _descriptionController.text;
    String tags = _descriptionController.text;

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    Feed newFeed = Feed(
        feedName: name,
        description: description.isNotEmpty ? description : null,
        tags: tags);

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newFeed);
      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Feed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Feed'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: FeedsListAdmin(feeds: _feeds),
      ),
    );
  }
}
/*
class FeedsList extends StatelessWidget {
  final List<Feed> feeds;

  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FeedsList({this.feeds});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              children: [
                Text('Feeds'),
                Container(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 62.0, 160, 10),
                  child: ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddFeedForm()),
                      );
                    },
                    child: Text('Add Feed'),
                  ),
                ))
              ],
            )),
        ListTile(
          title: Text('Feed 1'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Feed 2'),
          onTap: () {
            // Update the state of the app.
            // ...
            Navigator.pop(context);
          },
        ),
      feeds.map((feed) => FeedItems(feed: feed)).toList()
            
      ],
    );
  }
}

*/
/*
    

    PageView(
        controller: pageViewController,
        scrollDirection: Axis.horizontal,
        children: [
         
        ]); */

class FeedsList extends StatelessWidget {
  final List<Todo> todos;
  final List<Feed> feeds;

  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FeedsList({this.todos, this.feeds});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Container(
              child: feeds.length >= 1
                  ? ListView(
                      padding: EdgeInsets.fromLTRB(0, 229, 0, 0),
                      scrollDirection: Axis.vertical,
                      children:
                          feeds.map((feeds) => FeedItems(feed: feeds)).toList())
                  : Center(child: Text('Tap button below to add a todo!'))),
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.tealAccent,
              ),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 30, 0),
                      child: Text(
                        'Your Feeds',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"),
                      )),
                  Container(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 160, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddFeedForm()),
                        );
                      },
                      child: Text(
                        'Add Feed',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
                ],
              )),
        ],
      ),
    );
    /*
    PageView(
        controller: pageViewController,
        scrollDirection: Axis.horizontal,
        children: [
         
        ]); */
  }
}

class FeedsListAdmin extends StatelessWidget {
  final List<Todo> todos;
  final List<Feed> feeds;

  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FeedsListAdmin({this.todos, this.feeds});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Container(
              child: feeds.length >= 1
                  ? ListView(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      scrollDirection: Axis.vertical,
                      children:
                          feeds.map((feeds) => FeedItems(feed: feeds)).toList())
                  : Center(child: Text('Tap button below to add a todo!'))),
        ],
      ),
    );
    /*
    PageView(
        controller: pageViewController,
        scrollDirection: Axis.horizontal,
        children: [
         
        ]); */
  }
}

class FeedItemsAdmin extends StatelessWidget {
  final double iconSize = 24.0;
  final Feed feed;

  FeedItemsAdmin({this.feed});

  void _deleteFeed(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(feed);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    void _changeFeed() {
      Provider.of<FeedChanger>(context, listen: false)
          .changeFeed(feed.feedName);
    }

    ;

    return Card(
      child: InkWell(
        onLongPress: () {},
        onTap: () {
          // update the ui state to reflect fetched todos
          // feedID.value = feed.feedName;
          _changeFeed();

          //print(feedID.value);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feed.feedName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(feed.description ?? 'No description'),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
