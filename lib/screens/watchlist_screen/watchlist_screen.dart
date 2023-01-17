import 'package:flutter/material.dart';

class WatchListScreen extends StatelessWidget {
  static const String routeName = 'watchlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
      body: Center(
        child: Text(
          'Coming soon',
          style: TextStyle(color: Colors.white,fontSize: 20),
        ),
      ),
    );
  }
}
