//import 'responsive.dart';
import 'stockHistory.dart';
import 'package:flutter/material.dart';
import 'responsive.dart';

import '../../constants.dart';
import 'header.dart';

import 'SentimentHistory.dart';
import 'stockHistory.dart';

import 'storageDetails.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      //if (Responsive.isMobile(context)) StarageDetails(),
                      if (Responsive.isMobile(context)) StorageDetails(),

                      SizedBox(height: defaultPadding),
                      SentimentHistory(),
                      Text(""),
                      StockHistory(),

                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      //if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
