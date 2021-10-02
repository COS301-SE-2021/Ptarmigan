import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptarmigan/services/feed_file_manager.dart';
import 'package:ptarmigan/widgets/add_portfolio_page.dart';
import 'package:ptarmigan/widgets/dashboard_screen.dart';
import 'package:ptarmigan/widgets/feed_selector_screen.dart';
import 'package:ptarmigan/widgets/home_page.dart';
import 'package:ptarmigan/widgets/mainScreen.dart';
import 'package:ptarmigan/widgets/portfolio_page.dart';
import 'package:ptarmigan/widgets/stock_screen.dart';
import 'package:ptarmigan/widgets/todos_page.dart';
import 'package:ptarmigan/widgets/snapshot_inbox_screen.dart';

class MenuDrawer extends StatelessWidget {
  List feeds;
  FeedFileManager fileManager;
  MenuDrawer(this.feeds, this.fileManager);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text("Ptarmigan", style: TextStyle(fontSize: 30)),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            },
          ),
          DrawerListTile(
            title: "Insights",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen(manager)));
            },
          ),
          DrawerListTile(
            title: "Stocks",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StockScreen(feeds, fileManager)));
            },
          ),
          DrawerListTile(
            title: "Feed selector",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeedSelectorScreen(manager)));
            },
          ),
          DrawerListTile(
            title: "Snapshot Inbox",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TodoList()));
            },
          ),
          DrawerListTile(
            title: "Add portfolio page",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPortfolioPage()));
            },
          ),
          DrawerListTile(
            title: "Portfolio page",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PortfolioPage()));
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
