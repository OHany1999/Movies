import 'package:flutter/material.dart';

import '../screens/browse_screen/browse_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/search_screen/search_screen.dart';
import '../screens/watchlist_screen/watchlist_screen.dart';


class HomeLayout extends StatefulWidget {
  static const String routeName = 'layout';

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex= 0;

  List<Widget> widgetsList = [
    HomeScreen(),
    SearchScreen(),
    BrowseScreen(),
    WatchListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(26, 26, 26, 1.0),
        selectedItemColor: Color.fromRGBO(255, 187, 59, 1.0),
        unselectedItemColor: Color.fromRGBO(181, 180, 180, 1.0),
        currentIndex: currentIndex,
        onTap: (index){
          currentIndex =index;
          setState(() {

          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: 'SEARCH'),
          BottomNavigationBarItem(icon: Icon(Icons.movie),label: 'BROWSE'),
          BottomNavigationBarItem(icon: Icon(Icons.featured_play_list),label: 'WATCHLIST'),
        ],
      ),
      body: widgetsList[currentIndex],
    );
  }

}
