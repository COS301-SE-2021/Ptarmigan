import 'dart:ffi';

class PortfolioItem {
  var stockName;
  var amountOwned;
  var currentStockValue;
  late int timeStamp;

  PortfolioItem() {
    stockName = "";
    amountOwned = 0;
    currentStockValue = 0;
    timeStamp = 0;
  }

  void setPortfolioFromString(String portitem) {
    List tempList = portitem.split(',');
    timeStamp = int.parse(tempList[0]);
    amountOwned = tempList[1];
    currentStockValue = tempList[2];
  }

  String toStringWithName() {
    return stockName +
        "," +
        timeStamp.toString() +
        "," +
        amountOwned.toString() +
        "," +
        currentStockValue.toString();
  }

  String toStringWithoutName() {
    return timeStamp.toString() +
        "," +
        amountOwned.toString() +
        "," +
        currentStockValue.toString();
  }
}
