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
                  onPressed: null,
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
