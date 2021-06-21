import 'package:flutter/cupertino.dart';


class FeedChanger extends ChangeNotifier {
  var _feedChoice = "";

  String get getFeedChoice {
    return _feedChoice;
  }

  void changeFeed(String a) {
    _feedChoice = a;

    notifyListeners();
  }
}