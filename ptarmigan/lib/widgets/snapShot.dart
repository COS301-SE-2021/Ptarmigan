import 'package:flutter/material.dart';

typedef UpdateCallback = Function(String value, String id);
typedef DeleteCallback = Function(String id);

class SnapShot extends StatelessWidget {
  SnapShot(
      {required this.from,
      required this.to,
      required this.content,
      required this.sentiment,
      required this.stockPrice,
      required this.id,
      required this.update,
      required this.delete});

  final String from, to, content, id, sentiment, stockPrice;
  final UpdateCallback update;
  final DeleteCallback delete;
  TextEditingController updateText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    updateText.text = this.content;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: [
            Text(content,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600))
          ]),
          Row(children: [
            Text("Sentiment: " + sentiment,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500))
          ]),
          Row(children: [
            Text("Stock Price: " + stockPrice,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500))
          ]),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent, size: 20.0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  onPressed: () => this.delete(this.id))
            ],
          )
        ],
      ),
    );
  }
}
