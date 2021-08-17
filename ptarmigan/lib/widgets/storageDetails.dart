import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'StockAndSentimentValues.dart';
import 'graph.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

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
            "Bitcoin",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Sentiment Graph",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white60,
            ),
          ),
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
