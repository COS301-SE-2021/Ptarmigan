import 'dart:io';
import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptarmigan/services/feed_image_generator.dart';
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
    return Scaffold(
        appBar: AppBar(
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
        drawer: Drawer(),
        body: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hello"),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  //TwitterScreen("1424895584075354118")));
                                  TodosPage()));
                      //await feedimage = generator.fetchImages();
                      // var feedimage = await generator.fetchImages();
                      //print("feed image below:");
                      //print(feedimage);
                    },
                    child: Text("tweet"))
              ],
            ),
            Row(
              children: [
                Image.network("https://logo.clearbit.com/tesla.com"),
              ],
            ),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            )
          ]),
        ));
  }

  final List<Widget> imageSliders = [
    "https://logo.clearbit.com/tesla.com",
    "https://logo.clearbit.com/bitcoin.com",
    "https://logo.clearbit.com/neuralink.com",
    "https://logo.clearbit.com/tencent.com",
    "https://logo.clearbit.com/tesla.com",
  ]
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
    feedimage = await generator.fetchImages();

    for (var i = 0; i < feedimage.length; i++) {
      feedImageLink[i] = ("https://logo.clearbit.com/" + feedimage + ".com");
    }
    print(feedImageLink);
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
