import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'ProgressBar.dart';

class StockAndSentimentValues extends StatelessWidget {
  const StockAndSentimentValues({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    required this.percentage,
  }) : super(key: key);

  final String title, svgSrc, amountOfFiles;
  final int numOfFiles;
  final int percentage;

  Color colorDetermine(int i) {
    Color a = Colors.green;

    if (i < 30) {
      a = Colors.red;
    }

    if (i >= 30 && i <= 65) {
      a = Colors.amber;
    }

    if (i > 65) {
      a = Colors.green;
    }

    return a;
  }

  @override
  Widget build(BuildContext context) {
    int tester = 90;

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Current Sentiment:  " + tester.toString() + "%",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressBar(
            color: colorDetermine(tester),
            percentage: tester,
          ),
          Text(""),
          Text(
            "Current Stock Price:  " + "R160.43",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
