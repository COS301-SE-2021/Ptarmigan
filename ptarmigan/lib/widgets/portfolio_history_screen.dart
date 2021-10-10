import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/models/PortfolioItem.dart';
import 'package:ptarmigan/widgets/portfolio_page.dart';

import '../constants.dart';

class PortfolioHistoryScreen extends StatelessWidget {
  late Map portfolioMap;
  late String portfolioName;
  late List historyList;
  PortfolioHistoryScreen(String name, Map map) {
    print("PortfolioScreen initialized");
    portfolioMap = map;
    portfolioName = name;
    historyList = portfolioMap[portfolioName];
    print("historyList + $historyList");
  }

  @override
  Widget build(BuildContext context) {
    print("Beginning HistoryScreen build");
    print("HistoryList Length + " + historyList.length.toString());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PortfolioPage())),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(5, 10, 5, 10)),
              Text(
                portfolioName + " history",
                style: TextStyle(fontSize: 30),
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    color: bgColor,
                    //height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: DataTable2(
                      columnSpacing: defaultPadding,
                      minWidth: 350,
                      columns: [
                        DataColumn(
                          label: Text("Date"),
                        ),
                        DataColumn(
                          label: Text("Amount"),
                        ),
                        DataColumn(
                          label: Text("Value"),
                        ),
                      ],
                      rows: List.generate(
                        historyList.length,
                        (index) => recentFileDataRow(index),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  DataRow recentFileDataRow(int index) {
    PortfolioItem item = new PortfolioItem();
    item.setPortfolioFromString(historyList[index]);
    print("History list index($index) : " + item.toStringWithoutName());
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  formatDateTime(item.timeStamp),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(item.amountOwned)),
        DataCell(Text(item.currentStockValue)),
        //DataCell(Text(("#"))),
      ],
    );
  }

  String formatDateTime(int timeStamp) {
    return (DateTime.fromMillisecondsSinceEpoch(timeStamp).year.toString() +
            '-' +
            DateTime.fromMillisecondsSinceEpoch(timeStamp).month.toString() +
            '-' +
            DateTime.fromMillisecondsSinceEpoch(timeStamp).day.toString()
        // ' ' +
        //  DateTime.fromMillisecondsSinceEpoch(timeStamp).hour.toString() +
        //  ':' +
        //  DateTime.fromMillisecondsSinceEpoch(timeStamp).minute.toString());
        );
  }
}
