import 'package:flutter/material.dart';

class AddPortfolioPage extends StatefulWidget {
  const AddPortfolioPage();

  @override
  _AddPortfolioPageState createState() => _AddPortfolioPageState();
}

class _AddPortfolioPageState extends State<AddPortfolioPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter Stock Name"),
                onChanged: (text) {
                  
                }),
            ), 
            
          ],
        )
      ],),

    ));
  }
}