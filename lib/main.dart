import 'package:flutter/material.dart';
import 'package:movie/screens/home_screen/home_screen.dart';
import 'package:movie/screens/home_screen/details_screens/popular_details_screen.dart';

import 'home_layout/home_layout.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeLayout.routeName,
      routes: {
        HomeLayout.routeName: (context) => HomeLayout(),
        HomeScreen.routeName:(context)=>HomeScreen(),
        PopulerDetailsScreen.routeName:(context)=>PopulerDetailsScreen()
      },
    );
  }
}
