import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FeedFileManager {
  late Map<String, String> nameAndSubscription;
  late List feeds;

  bool initFeedMapComplete = false;

  //constructor
  FeedFileManager() {
    nameAndSubscription = Map();
    _initFeedMap();
    //this.feeds = feeds;

    //_initFeedMap();
  }

  void setFeedList(List feeds) {
    this.feeds = feeds;
    _resetFile(); //YOOOOOOO TAKE THIS SHIT OUT BRUHHHHH
    _initFeedFile();
  }

  Future<File> writeFeeds(List feeds) async {
    final file = await _localFile;
    print("Writing feeds.");
    for (int i = 0; i < feeds.length; i++) {
      var temp = feeds[i];
      print(temp);
      file.writeAsString("$temp");
    }
    return file;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    //return File('$path/lib/services/_data/feedList.txt');
    return File('$path/feedList.txt');
  }

  void _resetFile() async {
    print("RESETTING FILE. REMOVE IF NOT TESTING");

    final file = await _localFile;
    file.writeAsString("");
  }

  void _initFeedFile() async {
    final file = await _localFile;
    print("Init feed file.");
    print(await file.readAsString());
    if (await file.readAsString() == "") //empty
    {
      await createFile().then((value) => {_initFeedMap()});
    } else {
      updateFeedsFile();
      _initFeedMap();
    }
  }

  void _initFeedMap() async {
    print("initFeeds");

    final file = await _localFile; // might have to add await
    List lines = await file.readAsLines();

    for (int i = 0; i < lines.length; i++) {
      print("lines : " + lines[i]);
      List tempListOfNamesAndStatus = seperateLine(lines[i]);

      nameAndSubscription[tempListOfNamesAndStatus[0]] =
          tempListOfNamesAndStatus[1];
    }
    print(nameAndSubscription.toString());
  }

  Map getNamesAndSubMap() {
    return nameAndSubscription;
  }

  List seperateLine(String line) {
    int pos = line.indexOf(',');
    String name = line.substring(0, pos);
    String subStatus = line.substring(pos + 1, line.length);
    return [name, subStatus];
  }

  void updateFeedsFile() async {
    final file = await _localFile;
    var lines;
    bool changed = false;
    String holdFileContents = await file.readAsString();
    _initFeedMap(); //Might be redundant
    for (var v in feeds) {
      if (nameAndSubscription.containsKey(v) == false) {
        nameAndSubscription[v] == "False"; //add feed that was not in map.
        changed = true;
      }
    }
    if (changed) mapToFile(nameAndSubscription);
  }

  void mapToFile(Map<String, String> feedMap) async {
    final file = await _localFile;
    String toFile = "";
    for (var v in feedMap.keys) {
      var tempValue = feedMap[v];
      toFile += "$v,$tempValue\n";
    }
    file.writeAsString(toFile);
  }

  Future<void> createFile() async {
    print("File did not exist, creating file.");
    final file = await _localFile;
    String holdString = "";
    for (int i = 0; i < feeds.length; i++) {
      print("writing feed: " + feeds[i]);
      holdString += (feeds[i] + ",False\n");
    }
    file.writeAsString(holdString);
  }

  List getFeedList() {
    List temporaryFeedList = [];
    for (var v in nameAndSubscription.keys) {
      temporaryFeedList.add(v);
    }
    print("getFeedList called.");
    print(getFeedList().toString());
    return temporaryFeedList;
  }

  void changeSubscribed(String topic) {
    try {
      if (nameAndSubscription[topic] == null) throw ("$topic does not exist.");
      if (nameAndSubscription[topic] == "True")
        nameAndSubscription[topic] = "False";
      else if (nameAndSubscription[topic] == "False")
        nameAndSubscription[topic] = "True";
    } catch (e) {
      print(e);
    }
  }
}
