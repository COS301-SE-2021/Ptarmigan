import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

typedef UpdateCallback = Function(String value, String id);
typedef DeleteCallback = Function(String id);

class SnapShot extends StatelessWidget {
  SnapShot(
      {required this.time,
      required this.stockTitle,
      required this.from,
      required this.to,
      required this.content,
      required this.sentiment,
      required this.stockPrice,
      required this.id,
      required this.update,
      required this.delete});

  final String from, to, content, id, sentiment, stockPrice, stockTitle, time;
  final UpdateCallback update;
  final DeleteCallback delete;
  TextEditingController updateText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    updateText.text = this.content;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
          color: secondaryColor,
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: [
                    Text(stockTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(135, 1, 10, 1),
                      child: Text(
                          (DateTime.fromMillisecondsSinceEpoch(int.parse(time))
                              .toString()
                              .substring(0, 10)),
                          style: TextStyle(color: Colors.amber)),
                    )
                  ]),
                  Row(children: [
                    Text(
                        "Sentiment Score:  " +
                            (double.parse(sentiment) * 50 + 50).toString() +
                            "%",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500))
                  ]),
                  Row(children: [
                    Text("Stock Price:  \$" + stockPrice,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500))
                  ]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(2, 19, 2, 1),
                      child: Row(children: [
                        Expanded(
                            child: Text("Comment: \n" + content,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500)))
                      ])),
                  Padding(
                      padding: EdgeInsets.fromLTRB(230, 1, 1, 1),
                      child: Container(
                          color: bgColor,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.redAccent, size: 20.0),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () => this.delete(this.id))
                            ],
                          )))
                ],
              ))),
    );
  }
}
