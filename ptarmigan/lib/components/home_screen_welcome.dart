import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/constants.dart';

class WelcomeBox extends StatelessWidget {
  const WelcomeBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minWidth: MediaQuery.of(context).size.width,
          maxHeight: 200),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: buildWelcome(),
      ),
    );
  }

  Widget buildWelcome() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/gifs/graph.gif",
          fit: BoxFit.fitWidth,
          repeat: ImageRepeat.noRepeat,
  
        ),
        buildWelcomeText()
      ],
    );
  }

  Widget buildWelcomeText() {
    final Gradient gradient = LinearGradient(colors: [
      primaryColor,
      Colors.blue.shade900,
    ]);

    final text = "Ptarmigan";

    Future.delayed(Duration(seconds: 2));
    return Center(
        widthFactor: 1,
        child: ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            text,
            style: TextStyle(
              // The color must be set to white for this to work
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ));
  }
}
