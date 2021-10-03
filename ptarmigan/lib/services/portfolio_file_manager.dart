import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ptarmigan/models/PortfolioItem.dart';

class PortfolioFileManager {
  PortfolioFileManager() {
    initState();
  }
  late File globalFile;
  late List listFromTextFile;
  late Map<String, List> nameAndListMap = Map();

  initState() {
    //_initFile();
    initFile();
  }

  initFile() {
    print("Init portfolio file");
    bool tempReturn = false;
    _localFile.then((value) => {
          globalFile = value,
          initList()
        }); //Need this since _localFile has check to see if file exists
  }

  initList() {
    List lines = globalFile.readAsLinesSync();

    for (int i = 0; i < lines.length; i++) {
      print("lines : " + lines[i]);
      // List tempListOfNamesAndStatus = seperateLine(lines[i]);

      //   nameAndSubscription[tempListOfNamesAndStatus[0]] =
      //       tempListOfNamesAndStatus[1];
    }
    //  print(nameAndSubscription.toString());
    initMap(lines);
  }

  /*
    FILE FORMAT
    @
    STOCKNAME
    TIMESTAMP,AMOUNT OWNED,STOCKPRICE
    TIMESTAMP,AMOUNT OWNED,STOCKPRICE
    .
    .
    .
    =
    @
    STOCKNAME
    etc
  */

  initMap(List lines) {
    print("_InitMap called" + lines.toString());
    for (int i = 0; i < lines.length; i++) {
      String tempStockName = "";
      List tempPortfolioList = [];
      if (lines[i].toString().trim() == "@") {
        print("line init map = @");
        tempStockName = lines[i + 1];
        i = i + 1;
        while (lines[i].toString().trim() != "=") {
          if (lines[i].toString().trim() == "=") print(lines[i]);
          tempPortfolioList.add(lines[i]);
          i = i + 1;
        }
      }
      nameAndListMap[tempStockName] = tempPortfolioList;
    }
  }

  bool getMapEmpty() {
    return nameAndListMap.isEmpty;
  }

  void addNewPortfolio(PortfolioItem item) {
    print("addNewPortfolio = " + item.toStringWithName());
    List tempList = [item.toStringWithoutName()];
    nameAndListMap[item.stockName] = tempList;

    updatePortfolioFileWithMap();
  }

  void removePortfolio(String name) {
    print("removePortfolio = " + name);

    nameAndListMap.remove(name);

    updatePortfolioFileWithMap();
  }

  void resetFile() async {
    print("RESETTING FILE. REMOVE IF NOT TESTING");

    final file = await _localFile;
    nameAndListMap = new Map();
    file.writeAsString("");
  }

  void addIntoStockList(PortfolioItem item) {
    if (nameAndListMap.containsKey(item.stockName)) {
      List? tempList = nameAndListMap[item.stockName];

      String inputFormatted =
          item.timeStamp.toString() + "," + item.amountOwned;
      tempList!.add(inputFormatted);
      print("TempList = " + tempList.toString());
      nameAndListMap[item.stockName] = tempList;
      updatePortfolioFileWithMap();
    } else {
      throw Exception("Stock item does not exist in file");
    }
  }

  // WRITES NAME AND LIST MAP TO FILE
  void updatePortfolioFileWithMap() {
    globalFile.writeAsStringSync("");
    String addToFileString = "";
    List keyList = nameAndListMap.keys.toList();
    print("UpdatePortfolio keyList" + keyList.toString());
    for (int i = 0; i < keyList.length; i++) {
      addToFileString += "@\n";
      addToFileString += keyList[i] + "\n";
      List? tempPortfolioHistoryList = nameAndListMap[keyList[i]];
      for (int j = 0; j < tempPortfolioHistoryList!.length; j++) {
        addToFileString += tempPortfolioHistoryList[j] + "\n";
      }
      addToFileString += "=\n";
    }
    print("AddToFileString = " + addToFileString);
    globalFile.writeAsStringSync(addToFileString);
  }

  Future<Map> getNameAndListMap() async {
    return nameAndListMap;
  }

  List getNameList() {
    return nameAndListMap.keys.toList();
  }

  //FILE HELPER FUNCTIONS
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    //return File('$path/lib/services/_data/feedList.txt');
    File tempFile = File('$path/portfolio.txt');
    if (tempFile.existsSync() == false) tempFile.createSync();
    return tempFile;
  }
}
