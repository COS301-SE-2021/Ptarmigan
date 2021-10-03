import 'package:flutter/material.dart';
import 'package:ptarmigan/constants.dart';
import 'package:ptarmigan/models/PortfolioItem.dart';
import 'package:ptarmigan/services/portfolio_file_manager.dart';
import 'package:ptarmigan/widgets/home_page.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage();

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  Widget _body = Container(
      alignment: Alignment.center, child: CircularProgressIndicator());
  late PortfolioFileManager fileManager;

  _PortfolioPageState() {
    fileManager = new PortfolioFileManager();

    _initState();
  }

  _initState() {
    print("initState in Portfolio page");

    //while (fileManager.initMap == false) {
    // Future.delayed(Duration(milliseconds: 200));
    // }
    Future.delayed(Duration(seconds: 3)).then((value) => {
          fileManager.getNameAndListMap().then((value) => {
                setState(() {
                  print(value);
                  print("SetState called on portfolio page");
                  _body = generatePortfolioWidgetList(value);
                })
              })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _body,
    ));
  }

  Widget generatePortfolioWidgetList(Map portfolioMap) {
    List keysList = portfolioMap.keys.toList();
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(
        children: [for (var i in keysList) portfolioCard(i, portfolioMap[i])],
      ),
    )));
  }

  Widget portfolioCard(String name, List portfolioList) {
    String lastItemInList = portfolioList.last;
    PortfolioItem portfolioItem = new PortfolioItem();
    portfolioItem.stockName = name;
    portfolioItem.setPortfolioFromString(lastItemInList);
    /*return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(portfolioItem.stockName),
        Text(portfolioItem.timeStamp),
        Text(portfolioItem.amountOwned),
        Text(portfolioItem.currentStockValue),
      ],
    );*/

    return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: Text(name, style: TextStyle(fontSize: 30)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Amount holding : ",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  height: 30,
                  width: 100,
                  child: Text(portfolioItem.amountOwned.toString()),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Last stock price : ", style: TextStyle(fontSize: 20)),
                Container(
                  height: 30,
                  width: 100,
                  child: Text(portfolioItem.currentStockValue.toString()),
                )
              ],
            ),
            Container(
              height: 60,
              width: 200,
              child: Text(DateTime.fromMillisecondsSinceEpoch(
                      portfolioItem.timeStamp.round())
                  .toString()),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        update(portfolioItem);
                      },
                      child: Text("Update")),
                  ElevatedButton(
                      onPressed: () {
                        history(portfolioItem);
                      },
                      child: Text("History")),
                  ElevatedButton(
                      onPressed: () {
                        delete(portfolioItem);
                      },
                      child: Text("Delete")),
                ],
              ),
            ),
            Container(
              height: 30,
            )
          ],
        ));
  }

  void update(PortfolioItem item) {
    PortfolioItem tempItem = new PortfolioItem();
    tempItem.stockName = item.stockName;
    tempItem.amountOwned = item.amountOwned;
    //tempItem.currentStockValue
    tempItem.timeStamp = DateTime.now().millisecondsSinceEpoch;

    fileManager.addIntoStockList(tempItem);
  }

  void history(PortfolioItem item) {}

  void delete(PortfolioItem item) {
    fileManager.removePortfolio(item.stockName);
    setState(() {
      generatePortfolioWidgetList(fileManager.nameAndListMap);
    });
  }
}
