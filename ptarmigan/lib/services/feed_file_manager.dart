import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FeedFileManager {
  late Map<String, String> nameAndSubscription;
  late List feeds;

  bool initFeedMapComplete = false;

  //constructor
  FeedFileManager() {
    print("FFM Constructor");
    nameAndSubscription = Map();
    _initFile();

    //this.feeds = feeds;

    //_initFeedMap();
  }

  _initFile() async {
    print("Init file");
    final file =
        await _localFile; //Need this since _localFile has check to see if file exists

    _localFile.then((value) => {_initFeedMap(value)});
  }

  void _initFeedFile() async {
    final file = await _localFile;
    print("Init feed file.");
    //print(await file.readAsString());

    //await createFile().then((value) => {_initFeedMap()});

    if (await file.readAsString() == "") //empty
    {
      print("file was empty. Calling create file.");
      await createFile().then((value) async => {_initFeedMap(value)});
    }

    updateFeedsFile();
    if (initFeedMapComplete == false) _initFeedMap(file);
  }

  void _initFeedMap(File file) async {
    if (initFeedMapComplete == false) {
      print("init Feed Map");

      final file = await _localFile; // might have to add await
      List lines = file.readAsLinesSync();

      for (int i = 0; i < lines.length; i++) {
        print("lines : " + lines[i]);
        List tempListOfNamesAndStatus = seperateLine(lines[i]);

        nameAndSubscription[tempListOfNamesAndStatus[0]] =
            tempListOfNamesAndStatus[1];
      }
      print(nameAndSubscription.toString());
      initFeedMapComplete = true;
    }
  }

  void setFeedList(List feeds) {
    print("Set feed list.");

    this.feeds = feeds;
    print("Feedslist = $feeds");
    //_resetFile(); //YOOOOOOO TAKE THIS SHIT OUT BRUHHHHH
    //_initFeedFile();
    updateFeedsFile();
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
    File tempFile = File('$path/feedList.txt');
    if (tempFile.existsSync() == false) tempFile.createSync();
    return tempFile;
  }

  void _resetFile() async {
    print("RESETTING FILE. REMOVE IF NOT TESTING");

    final file = await _localFile;
    file.writeAsString("");
  }

  Future<Map> getNamesAndSubMap() async {
    print("NameANDSubscription.");
    print(nameAndSubscription);
    return nameAndSubscription;
  }

  List seperateLine(String line) {
    int pos = line.indexOf(',');
    String name = line.substring(0, pos);
    String subStatus = line.substring(pos + 1, line.length);
    return [name, subStatus];
  }

  void updateFeedsFile() async {
    print("Update feeds file");
    final file = await _localFile;
    var lines;
    bool changed = false;
    String holdFileContents = await file.readAsString();
    //_initFeedMap(); //Might be redundant
    for (var v in feeds) {
      //Checks to see if there are new feeds to add
      print("$nameAndSubscription in updateFeedsFile");
      if (nameAndSubscription.containsKey(v) == false) {
        nameAndSubscription.putIfAbsent(v, () => "False");
        // nameAndSubscription[v] == "False"; //add feed that was not in map.
        print("Updated nameandsub = $v");
        changed = true;
      }
    }
    List tempList = nameAndSubscription.keys.toList();
    for (var v in tempList) {
      if (feeds.contains(v) == false) {
        nameAndSubscription.remove(v);
      }
    }

    print("$nameAndSubscription in updateFeedsFile");

    if (changed) mapToFile(nameAndSubscription);
  }

  void mapToFile(Map<String, String> feedMap) async {
    final file = await _localFile;
    String toFile = "";
    for (var v in feedMap.keys) {
      var tempValue = feedMap[v];
      toFile += "$v,$tempValue\n";
    }
    print("ADDING FOLLOWING TO FILE : \n $toFile");
    file.writeAsString(toFile);
  }

  Future<File> createFile() async {
    print("File was empty.");
    final file = await _localFile;
    String holdString = "";
    for (int i = 0; i < feeds.length; i++) {
      print("writing feed: " + feeds[i]);
      holdString += (feeds[i] + ",False\n");
    }
    file.writeAsString(holdString);

    return file;
  }

  Future<List> getFeedList() async {
    List temporaryFeedList = [];
    for (var v in nameAndSubscription.keys) {
      temporaryFeedList.add(v);
    }

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
