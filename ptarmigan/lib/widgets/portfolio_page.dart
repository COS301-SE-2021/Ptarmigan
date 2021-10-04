import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/constants.dart';
import 'package:ptarmigan/models/PortfolioItem.dart';
import 'package:ptarmigan/services/portfolio_file_manager.dart';
import 'package:ptarmigan/services/stock_price_generator.dart';
import 'package:ptarmigan/widgets/home_page.dart';
import 'package:ptarmigan/widgets/portfolio_history_screen.dart';

import 'add_portfolio_page.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage();

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  Widget _body = Container(
      alignment: Alignment.center, child: CircularProgressIndicator());
  late PortfolioFileManager fileManager;
  late Map portMap;
  late String stockAmountOwnedData;

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
                  portMap = value;
                  print("SetState called on portfolio page");
                  if (value.isEmpty)
                    _body = emptyFileWidget();
                  else
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
            appBar: AppBar(
              title: Text("Portfolio"),
              backgroundColor: bgColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen())),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i in keysList) portfolioCard(i, portfolioMap[i]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PortfolioPage()));
                            },
                            child: Text(
                              "Refresh",
                              style: TextStyle(fontSize: 25),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddPortfolioPage()));
                            },
                            child: Text(
                              "Add item",
                              style: TextStyle(fontSize: 25),
                            )),
                      ])
                ],
              ),
            )));
  }

  Widget emptyFileWidget() {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No portfolio items have been added yet.",
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPortfolioPage()));
              },
              child: Text(
                "Add item.",
                style: TextStyle(fontSize: 15),
              ))
        ],
      ),
    );
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
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlueAccent, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(name, style: TextStyle(fontSize: 30)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Amount holding : ",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  height: 25,
                  width: 100,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                    controller: TextEditingController(
                      text: portfolioItem.amountOwned,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() {
                        stockAmountOwnedData = text;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Last stock price : ", style: TextStyle(fontSize: 20)),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  height: 30,
                  width: 100,
                  child: Text(portfolioItem.currentStockValue.toString(),
                      style: TextStyle(fontSize: 20)),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 1, color: Colors.white))),
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              height: 60,
              width: 200,
              child: Text(
                  DateTime.fromMillisecondsSinceEpoch(
                          portfolioItem.timeStamp.round())
                      .toString(),
                  style: TextStyle(fontSize: 15)),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        portfolioItem.amountOwned = stockAmountOwnedData;
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
            ),
          ],
        ));
  }

  void update(PortfolioItem item) {
    StockPriceGenerator generator = new StockPriceGenerator();
    PortfolioItem tempItem = new PortfolioItem();
    tempItem.stockName = item.stockName;
    tempItem.amountOwned = item.amountOwned;

    tempItem.timeStamp = DateTime.now().millisecondsSinceEpoch;
    generator.fetchPrices().then((value) => {
          tempItem.currentStockValue = value[tempItem.stockName],
          print("tempItem = " + tempItem.toStringWithName()),
          fileManager.addIntoStockList(tempItem)
        });
  }

  void history(PortfolioItem item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PortfolioHistoryScreen(item.stockName, portMap)));
  }

  void delete(PortfolioItem item) {
    fileManager.removePortfolio(item.stockName);
    setState(() {
      generatePortfolioWidgetList(fileManager.nameAndListMap);
    });
  }
}
