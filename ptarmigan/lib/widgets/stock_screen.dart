import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptarmigan/services/stock_price_generator.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

StockPriceGenerator stockgenerator = StockPriceGenerator();

class StockScreen extends StatefulWidget {
  var feedList;
  StockScreen({this.feedList});

  @override
  _StockScreenState createState() => _StockScreenState(feedList);
}

class _StockScreenState extends State<StockScreen> {
  var feedList;
  var stockPrices;
  _StockScreenState(this.feedList);

  void initState() {
    print("Initiating stock screen");
    _initStockPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //Navigator.push(context,
              //  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          title: Text('Dashboard'),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [
            Text("Hello there"),
            ElevatedButton(
                onPressed: () {
                  print(" Prices output : ");
                  print(stockPrices);
                },
                child: Text("Test button")),
            Container(
                height: 500,
                width: double.infinity,
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: feedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 70,
                        color: Colors.white, // change via settings page
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(feedList[index] +
                                      " : " +
                                      printStockPrice(index))),
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TodosPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
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
}
