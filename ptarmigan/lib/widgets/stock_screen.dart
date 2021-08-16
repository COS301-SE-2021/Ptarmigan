import 'package:flutter/material.dart';
import 'package:ptarmigan/widgets/todos_page.dart';

import 'home_page.dart';

class StockScreen extends StatefulWidget {
  var feedList;
  StockScreen({this.feedList});

  @override
  _StockScreenState createState() => _StockScreenState(feedList);
}

class _StockScreenState extends State<StockScreen> {
  var feedList;

  _StockScreenState(this.feedList);

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
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: feedList,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70,
                    color: Colors.white, // change via settings page
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(feedList[index]),
                          Text(getStockPrice(feedList[index]))
                        ],
                      ),
                    ),
                  );
                })
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

  String getStockPrice(String stockName) {
    //call api using stock name
    return " ";
  }
}
