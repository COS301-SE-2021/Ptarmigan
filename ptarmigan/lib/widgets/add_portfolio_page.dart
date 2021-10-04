import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ptarmigan/constants.dart';
import 'package:ptarmigan/models/PortfolioItem.dart';
import 'package:ptarmigan/services/portfolio_file_manager.dart';
import 'package:ptarmigan/services/stock_price_generator.dart';
import 'package:ptarmigan/widgets/portfolio_page.dart';

class AddPortfolioPage extends StatefulWidget {
  const AddPortfolioPage();

  @override
  _AddPortfolioPageState createState() => _AddPortfolioPageState();
}

class _AddPortfolioPageState extends State<AddPortfolioPage> {
  PortfolioFileManager manager = new PortfolioFileManager();
  final _formKey = GlobalKey<FormState>();

  StockPriceGenerator generator = new StockPriceGenerator();
  var stockPrices;
  String stockNameInputData = "";
  String stockTicketInputData = "";
  String stockAmountOwnedInputData = "";
  TextEditingController stockPriceData = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PortfolioPage())),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stock name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }
                    return null;
                  },
                  onChanged: (text) {
                    setState(() {
                      stockNameInputData = text;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Enter amount owned"),
                      Container(
                        height: 80,
                        width: 130,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Value..."),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                          onChanged: (text) {
                            setState(() {
                              stockAmountOwnedInputData = text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Enter ticker symbol"),
                      Container(
                        height: 80,
                        width: 130,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Ticker..."),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                          onChanged: (text) {
                            setState(() {
                              stockTicketInputData = text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        generator.fetchPrices().then((value) => {
                              setState(() {
                                stockPrices = value;
                                print(stockPrices);
                                print("StockName " + stockNameInputData);
                                stockPriceData = TextEditingController(
                                    text: stockPrices[stockNameInputData]);
                              })
                            });
                      },
                      child: Text("Fetch Stock price")),
                  Container(
                    height: 80,
                    width: 180,
                    child: TextFormField(
                      controller: stockPriceData,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Or enter manually..."),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() {
                          stockTicketInputData = text;
                        });
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      PortfolioItem tempNewItem = new PortfolioItem();
                      tempNewItem.stockName = stockNameInputData;
                      tempNewItem.timeStamp =
                          (DateTime.now().millisecondsSinceEpoch);
                      tempNewItem.amountOwned =
                          int.parse(stockAmountOwnedInputData);
                      tempNewItem.currentStockValue =
                          double.parse(stockPriceData.text);
                      manager.addNewPortfolio(tempNewItem);
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              // ElevatedButton(              //For debugging purposes
              // onPressed: () {
              //   manager.resetFile();
              // },
              // child: Text("ResetFile"))
            ],
          ),
        ));
  }

  _initState() {}

  void _initStockPrices() async {
    var stockPricestemp = await generator.fetchPrices();
    if (stockPricestemp != null)
      setState(() {
        stockPrices = stockPricestemp;
      });
    //try {
    // for (var i = 0; i < feedList.length; i++) {
    //  print(stockPrices[feedList[i]]);
    // }
    // } on NoSuchMethodError catch (e) {}
  }
}
