import 'dart:io';
import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/components/home_screen_welcome.dart';
import 'package:ptarmigan/components/menu_drawer.dart';
import 'package:ptarmigan/constants.dart';
import 'package:ptarmigan/services/feed_image_generator.dart';
import 'package:ptarmigan/settings/application_settings.dart';
import 'package:ptarmigan/widgets/Settings_page.dart';
import 'package:ptarmigan/widgets/stock_screen.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:ptarmigan/widgets/twitter_page.dart';
import 'package:social_embed_webview/platforms/twitter.dart';
import 'package:social_embed_webview/social_embed_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

var feedimage;
var feedImageLink;

FeedImageGenerator generator = FeedImageGenerator();

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late AuthUser _user;

  @override
  void initState() {
    print("Home page loaded.");
    _initFeedInterests();
    print("-=-=-=-=-=-=-=-=-=-=-=-=-");

    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
    // Amplify.Auth.getCurrentUser().then((user) {
    //  setState(() {
    //   _user = user;
    // });
    // }).catchError((error) {
    //   print(error.message as AuthException);
    //  });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Settings();
    return Scaffold(
        backgroundColor: bgColor,
        drawer: MenuDrawer(),
        appBar: AppBar(
          backgroundColor: bgColor,
          shadowColor: secondaryColor,
          title: Text('Dashboard'),
          actions: [
            MaterialButton(
                onPressed: () {
                  Amplify.Auth.signOut().then((_) {
                    Navigator.pushReplacementNamed(context, '/login');
                  });
                },
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        //Drawer

        body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                WelcomeBox(),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: secondaryColor.withOpacity(0.6),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Text(
                                "Curious about our info?",
                                textAlign: TextAlign.center,
                              )),
                          Container(
                            alignment: Alignment.center,
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: secondaryColor.withOpacity(0.6),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                                child: Text(
                                  "Click here for the tweet!",
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TwitterScreen(
                                              1426541125498810368)));
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all(CircleBorder()),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(20)),
                                  backgroundColor: MaterialStateProperty.all(
                                      primaryColor), // <-- Button color
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (states) {
                                    if (states.contains(MaterialState.pressed))
                                      return secondaryColor; // <-- Splash color
                                  }),
                                )),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              height: 190,
                              width: 200,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: secondaryColor.withOpacity(0.6),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Text(
                                "Have a look at the most impactful tweet of the day!",
                                textAlign: TextAlign.center,
                              )),
                        ],
                      )
                    ],
                  ),
                ),

                /*CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            )*/
                SizedBox(height: 40),
                Text(
                  "Stocks we provide insights to:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  color: secondaryColor,
                  child: CarouselSlider.builder(
                    itemCount: feedimage.length,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    itemBuilder: (context, index, realIdx) {
                      return Container(
                          child: Center(
                        child: Stack(children: [
                          Image.network(
                              "https://logo.clearbit.com/" +
                                  feedimage[index] +
                                  ".com",
                              fit: BoxFit.cover,
                              width: 1000),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                feedimage[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ));
                    },
                  ),
                ),
                Text(
                  "About us :",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  color: secondaryColor,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 300,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        """We are a group of University students who are extremely passionate about learning new technologies and developing cutting edge technology and systems.

                      \n For any enquiries please contact us via our email: 
                      onemorebytecos301@gmail.com

                            This code is open source and is available on GitHub: 
                            github.com/COS301-SE-2021/Ptarmigan
                    """,
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                )
              ]),
            )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), label: "Insights"),
            BottomNavigationBarItem(icon: Icon(Icons.grade), label: "Stocks"),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: _OnItemTapped,
        ));
  }

  void _OnItemTapped(int index) {
    switch (index) {
      case 0:
        //Navigator.push(context,
        //  MaterialPageRoute(builder: (context) => DashboardScreen()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TodosPage()));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StockScreen(
                      feedList: feedimage,
                    )));
        break;
    }
  }

  late final List<Widget> imageSliders = feedImageLink
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            "text",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  Future<void> _initFeedInterests() async {
    print("FETCHING FEED IMAGES");
    feedimage = await generator.fetchImages();
    if (feedimage == null) feedimage = ["Apple"];

    // if (feedimage != null) {
    /*for (var i = 0; i < feedimage.length; i++) {
        try {
          feedImageLink[i] = ("https://logo.clearbit.com/" +
              (feedimage[i] as String) +
              ".com");
        } on NoSuchMethodError catch (e) {
          print("Null throw occurred");
        }
      }
    }*/
    //print(feedImageLink);
  }

  List getFeedImages() {
    return feedimage;
  }
}

/*
WebView(
  initialUrl:
  'https://twitter.com/ZacksJerryRig/status/1424895584075354118',
  //'https://www.youtube.com/watch?v=HNODkS9gZmM',
  javascriptMode: JavascriptMode.unrestricted,
  )
  */
