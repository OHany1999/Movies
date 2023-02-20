import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/home/home_screen_models_for_navigate/new_releases_model.dart';
import 'package:movie/models/search/Search.dart';
import 'package:movie/screens/browse_screen/movie_category_screen.dart';
import 'package:movie/screens/details_screens/details_screen.dart';
import 'package:movie/screens/home_screen/home_screen.dart';


import 'firebase_options.dart';
import 'home_layout/home_layout.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        CategoryMoviesScreen.routeName:(context)=>CategoryMoviesScreen(),
        DetailsScreen.routeName:(context)=>DetailsScreen(),
      },
    );
  }
}
