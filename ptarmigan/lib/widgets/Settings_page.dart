import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //Navigator.push(context,
              //  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          title: Text('Dashboard'),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: [

            Text("Hello there"),
            
          ],
        ));
  }
}
