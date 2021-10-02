import 'package:flutter/material.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage();

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  Widget _body = CircularProgressIndicator();

  _initState()
  {
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: _body,
    ));
  }
}
