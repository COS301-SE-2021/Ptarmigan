import 'package:flutter/material.dart';
import 'package:ptarmigan/services/feed_changer.dart';

import '../../../constants.dart';
import 'StockAndSentimentValues.dart';
import 'SentimentHistory.dart';
import 'package:provider/provider.dart';

import 'graph.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
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
            Provider.of<FeedChanger>(context, listen: false).getFeedChoice,
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
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    );
                  },
                  child: Text(
                    "Send snapshot",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ]),
          SizedBox(),
          Graph(),
          StockAndSentimentValues(
            svgSrc: "assets/icons/folder.svg",
            title: "Other Files",
            amountOfFiles: "1.3GB",
            numOfFiles: 1328,
            percentage: 10,
          ),
        ],
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Send Snapshot'),
    insetPadding: EdgeInsets.fromLTRB(1, 1, 1, 1),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Recipients email address:"),
        TextField(),
        Padding(
            child: Text("Comment:"),
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10)),
        TextField(),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Close',
          style: TextStyle(color: Colors.white),
        ),
      ),
      new ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Send',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
