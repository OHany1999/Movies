import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/browse/Discover.dart';
import 'package:movie/models/browse/browse_screen_model_for_navigator/id_model.dart';
import 'package:movie/models/main_details_Screen_model.dart';
import 'package:movie/models/search/Search.dart';
import 'package:movie/models/search/search_details_model.dart';
import 'package:movie/screens/details_screens/details_screen.dart';
import 'package:movie/shared/api/api_manager.dart';
import 'package:movie/shared/constants/constants.dart';

import '../../models/friebase_model/watch_list_model.dart';
import '../../shared/firebase/firebase_utils.dart';

class WatchListScreen extends StatefulWidget {
  static const String routeName = 'watchlist';

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  var get_gata_from_fireStore =getDataFromFireStore();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Your WatchList',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<WatchListModel>>(
            stream: get_gata_from_fireStore,
            builder: (context,snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Container());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text('Something went wrong'),
                      TextButton(
                        onPressed: () {},
                        child: Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }
              List<WatchListModel> firebaseList = snapshot.data!.docs.map((event) => event.data()).toList();
              var firebaseMovieIdList = firebaseList.map((docs) => docs.movieId).toList();
              return ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments:DetailsModel(
                            firebaseList[index].title,
                            firebaseList[index].imageUrl,
                            firebaseList[index].date,
                            firebaseList[index].movieId,
                            firebaseList[index].posterPath,
                            firebaseList[index].voteAverage.toString(),
                          )
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          if (firebaseList[index].imageUrl !=null)
                            Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image(
                                    image: NetworkImage(
                                        '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + firebaseList[index].imageUrl}'),
                                    width: 140,
                                    height: 130,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    if(firebaseMovieIdList.contains(firebaseMovieIdList[index])){
                                      deleteWatchListFromFireStore(firebaseMovieIdList[index]);
                                      print('is exist ');
                                    }
                                    setState(() {});
                                  },
                                  child:
                                  firebaseMovieIdList.contains(firebaseMovieIdList[index])?
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                    child: Image.asset('assets/images/bookmark2.png',),):
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                    child: Image.asset('assets/images/bookmark.png',),
                                  ),
                                ),
                              ],
                            ),
                          if (firebaseList[index].imageUrl ==null)
                            Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/movie.jpg'),
                                    width: 140,
                                    height: 130,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    if(firebaseMovieIdList.contains(firebaseMovieIdList[index])){
                                      deleteWatchListFromFireStore(firebaseMovieIdList[index]);
                                      print('is exist ');
                                    }
                                    setState(() {});
                                  },
                                  child:
                                  firebaseMovieIdList.contains(firebaseMovieIdList[index])?
                                  Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Image.asset('assets/images/bookmark2.png',),):
                                  Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Image.asset('assets/images/bookmark.png',),
                                  ),
                                ),
                              ],
                            ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${firebaseList[index].title}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    '${firebaseList[index].date}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            181, 180, 180, 1.0),
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    '${firebaseList[index].description}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            181, 180, 180, 1.0),
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Container(
                  width: 1,
                  height: 0.6,
                  color: Color.fromRGBO(181, 180, 180, 1.0),
                ),
                itemCount: firebaseList.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
