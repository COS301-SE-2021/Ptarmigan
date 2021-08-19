import 'package:flutter/cupertino.dart';

class ListChanger extends ChangeNotifier {
  var list = [];

  List get getList {
    return list;
  }

  void changeList(List a) {
    list = a;

    notifyListeners();
  }
}
