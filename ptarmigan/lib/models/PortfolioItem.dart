import 'dart:ffi';

class PortfolioItem {
  var stockName;
  var amountOwned;
  var currentStockValue;
  var timeStamp;

  PortfolioItem() {
    stockName = "";
    amountOwned = 0;
    currentStockValue = 0;
    timeStamp = 0;
  }

  void setPortfolioFromString(String portitem) {
    List tempList = portitem.split(',');
    timeStamp = tempList[0];
    amountOwned = tempList[1];
    currentStockValue = tempList[2];
  }

  String toStringWithName() {
    return stockName +
        "," +
        timeStamp +
        "," +
        amountOwned +
        "," +
        currentStockValue;
  }

  String toStringWithoutName() {
    return timeStamp.toString() +
        "," +
        amountOwned.toString() +
        "," +
        currentStockValue.toString();
  }
}
