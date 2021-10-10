import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/components/menu_drawer.dart';
import 'package:ptarmigan/constants.dart';
import 'package:ptarmigan/services/feed_file_manager.dart';
import 'package:ptarmigan/services/stock_price_generator.dart';
import 'package:ptarmigan/widgets/dashboard_screen.dart';
import 'package:ptarmigan/widgets/mainScreen.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

StockPriceGenerator stockgenerator = StockPriceGenerator();

class StockScreen extends StatefulWidget {
  var feedList;
  FeedFileManager fileManager;
  StockScreen(this.feedList, this.fileManager);

  @override
  _StockScreenState createState() => _StockScreenState(feedList, manager);
}

class _StockScreenState extends State<StockScreen> {
  var feedList;
  var stockPrices;
  FeedFileManager manager;
  _StockScreenState(this.feedList, this.manager);

  void initState() {
    print("Initiating stock screen");
    _initStockPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuDrawer(feedList, manager),
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Text('Dashboard'),
          actions: [
            /*MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                ))*/
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10)),
                Text(
                  "Historical stock data",
                  style: TextStyle(fontSize: 30),
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      color: bgColor,
                      width: MediaQuery.of(context).size.width,
                      child: DataTable2(
                        columnSpacing: defaultPadding,
                        minWidth: 400,
                        columns: [
                          DataColumn(
                            label: Text("Stock name"),
                          ),
                          DataColumn(
                            label: Text("Worth"),
                          ),
                        ],
                        rows: List.generate(
                          feedList.length,
                          (index) => recentFileDataRow(index),
                        ),
                      ),
                    ))
              ],
            )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), label: "Insights"),
            BottomNavigationBarItem(icon: Icon(Icons.grade), label: "Stocks"),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: _OnItemTapped,
        ));
  }

  void _OnItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(manager)));
        break;
      case 2:
        //Navigator.push(context,
        //  MaterialPageRoute(builder: (context) => DashboardScreen()));
        break;
    }
  }

  String printStockPrice(int index) {
    if (stockPrices != null)
      return stockPrices[feedList[index]];
    else
      return "Loading data...";
  }

  void _initStockPrices() async {
    var stockPricestemp = await stockgenerator.fetchPrices();
    if (stockPricestemp != null)
      setState(() {
        stockPrices = stockPricestemp;
      });
    try {
      for (var i = 0; i < feedList.length; i++) {
        print(stockPrices[feedList[i]]);
      }
    } on NoSuchMethodError catch (e) {}
  }

  DataRow recentFileDataRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(feedList[index]),
              ),
            ],
          ),
        ),
        DataCell(Text("\$" + printStockPrice(index))),
        //DataCell(Text(("#"))),
      ],
    );
  }
}
