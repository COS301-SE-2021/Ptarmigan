import 'package:flutter/material.dart';
import 'package:ptarmigan/services/feed_changer.dart';

import '../../../constants.dart';
import 'StockAndSentimentValues.dart';
import 'SentimentHistory.dart';
import 'package:provider/provider.dart';
import 'fire_Base_DB.dart';
import 'graph.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'singletonGlobal.dart';

final StockAndSentimentValues stockAndSent = StockAndSentimentValues();

class StorageDetails extends StatelessWidget {
  StorageDetails({
    Key? key,
  }) : super(key: key);

  String setTitle(String a) {
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Provider.of<FeedChanger>(context, listen: true).getFeedChoice,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(children: [
            Text(
              "Sentiment Graph",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white60,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(3, 0, 0, 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: bgColor),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return SnapShotForm();
                          });
                        });
                  },
                  child: Text(
                    "Send snapshot",
                    style: TextStyle(color: Colors.amber),
                  )),
            )
          ]),
          SizedBox(),
          Graph(),
          //StockAndSentimentValues(),
          stockAndSent,
        ],
      ),
    );
  }
}

void _sendSnapShot(StockAndSentimentValues tes, String email, String comment,
    String name) async {
  AuthUser a = await AmplifyAuthCognito().getCurrentUser();

  // print("PING: " + a.username);

  var task = <String, dynamic>{
    'stocktitle': tes.feedName,
    'to': email,
    'from': a.username,
    'content': comment,
    'sentiment': tes
        .currentSentiment, //(int.parse(tes.currentSentiment) * 50 + 50).toString() + '%',
    'stock': tes.currentStock,
    'timestamp': DateTime.now().millisecondsSinceEpoch
  };

  print("hag");
  Database.addSnapShot(task);
}

// Define a custom Form widget.
class SnapShotForm extends StatefulWidget {
  const SnapShotForm({Key? key}) : super(key: key);

  @override
  _SnapShotWidget createState() => _SnapShotWidget();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SnapShotWidget extends State<SnapShotForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return new AlertDialog(
      backgroundColor: secondaryColor,
      title: const Text('Send Snapshot'),
      insetPadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
      content: new Container(
        height: 170,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Recipients email address:"),
            TextField(
              controller: myController1,
            ),
            Padding(
                child: Text("Comment:"),
                padding: EdgeInsets.fromLTRB(10, 1, 10, 1)),
            Padding(
              padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
              child: TextField(
                controller: myController2,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(primary: bgColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.amber),
          ),
        ),
        new ElevatedButton(
          style: ElevatedButton.styleFrom(primary: bgColor),
          onPressed: () {
            Navigator.of(context).pop();
            _sendSnapShot(stockAndSent, myController1.text, myController2.text,
                Provider.of<FeedChanger>(context, listen: false).getFeedChoice);
          },
          child: const Text(
            'Send',
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ],
    );
  }
}
