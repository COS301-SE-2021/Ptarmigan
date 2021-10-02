import 'package:flutter/material.dart';
import 'package:ptarmigan/models/PortfolioItem.dart';
import 'package:ptarmigan/services/portfolio_file_manager.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage();

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  Widget _body = Container(
      alignment: Alignment.center, child: CircularProgressIndicator());
  PortfolioFileManager fileManager = new PortfolioFileManager();
  _initState() {
    if (fileManager.getMapEmpty()) {
      //do absolutely nothing
    } else {
      setState(() {
        _body = generatePortfolioWidgetList(fileManager.getNameAndListMap());
      });
    }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(portfolioItem.stockName),
        Text(portfolioItem.timeStamp),
        Text(portfolioItem.amountOwned),
        Text(portfolioItem.currentStockValue),
      ],
    );
  }
}
