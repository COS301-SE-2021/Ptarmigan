import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

typedef UpdateCallback = Function(String value, String id);
typedef DeleteCallback = Function(String id);

class NewsEntity extends StatelessWidget {
  NewsEntity({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
  });

  final String title, description, content, url, urlToImage;

  @override
  Widget build(BuildContext context) {
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
                    Text(title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                    /*     Padding(
                      padding: EdgeInsets.fromLTRB(180, 1, 1, 1),
                      child: Text(
                          (DateTime.fromMillisecondsSinceEpoch(int.parse(time))
                              .toString()
                              .substring(0, 10)),
                          style: TextStyle(color: Colors.amber)),
                    ) */
                  ]),
                  Row(children: [
                    Text("Sentiment: " + description,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500))
                  ]),
                  Row(children: [
                    Text("Stock Price: \$" + content,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500))
                  ]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(2, 19, 2, 1),
                      child: Row(children: [
                        Expanded(
                            child: Text("Comment: \n" + url,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500)))
                      ])),
                  Row(children: [
                    Text("Sentiment: " + urlToImage,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500))
                  ]),
                ],
              ))),
    );
  }
}
