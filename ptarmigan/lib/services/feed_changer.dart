import 'package:flutter/cupertino.dart';

class FeedChanger extends ChangeNotifier {
  var _feedChoice = "";

  String get getFeedChoice {
    return _feedChoice;
  }

  Future<void> changeFeed(String a) async {
    _feedChoice = a;

    notifyListeners();
  }
}
