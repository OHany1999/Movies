import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/search/Search.dart';
import 'package:movie/models/search/search_details_model.dart';
import 'package:movie/shared/api/api_manager.dart';
import 'package:movie/shared/constants/constants.dart';

import '../../models/friebase_model/watch_list_model.dart';
import '../../models/main_details_Screen_model.dart';
import '../../shared/firebase/firebase_utils.dart';
import '../details_screens/details_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String data = '';
  var get_gata_from_fireStore =getDataFromFireStore();

  @override
  Widget build(BuildContext context) {
    var getSearch =ApiManager.getSearch(data);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<WatchListModel>>(
            stream: get_gata_from_fireStore,
            builder:(context,mainSnapshot){
              if (mainSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Container());
              }
              if (mainSnapshot.hasError) {
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
              List<WatchListModel> firebaseList = mainSnapshot.data!.docs.map((event) => event.data()).toList();
              var firebaseMovieIdList = firebaseList.map((docs) => docs.movieId).toList();
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(81, 79, 79, 1.0),
                        label: Text(
                          'search',
                          style:
                          TextStyle(color: Color.fromRGBO(181, 180, 180, 1.0)),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onChanged: (text) {
                        data = text;
                        setState(() {});
                      },
                    ),
                  ),
                  FutureBuilder<Search>(
                      future: getSearch,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            margin: EdgeInsets.only(top: 300),
                            child: CircularProgressIndicator(),
                          );
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
                        if (data.trim() == '' ) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 90),
                                  child:
                                  Image.asset('assets/images/NoMovies.png')),
                            ],
                          );
                        }
                        var IdList = snapshot.data!.results!.map((docs) =>docs.id.toString()).toList();
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.pushNamed(
                                    context,
                                    DetailsScreen.routeName,
                                    arguments:DetailsModel(
                                      snapshot.data!.results![index].title!,
                                      snapshot.data!.results![index].backdropPath!,
                                      snapshot.data!.results![index].releaseDate!,
                                      snapshot.data!.results![index].id.toString(),
                                      snapshot.data!.results![index].posterPath!,
                                      snapshot.data!.results![index].voteAverage.toString(),
                                    )
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    if(snapshot.data?.results?[index].backdropPath != null)
                                      Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image(
                                              image: NetworkImage(
                                                  '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].backdropPath!}'),
                                              width: 140,
                                              height: 130,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              WatchListModel watchList=WatchListModel(
                                                movieId: snapshot.data!.results![index].id.toString(),
                                                imageUrl: snapshot.data!.results![index].backdropPath!,
                                                date: snapshot.data!.results![index].releaseDate!,
                                                title: snapshot.data!.results![index].title!,
                                                description: snapshot.data!.results![index].overview!,
                                              );
                                              if(firebaseMovieIdList.contains(IdList[index])){
                                                deleteWatchListFromFireStore(IdList[index]);
                                                print('is exist ');
                                              }else{
                                                addWatchListToFireStore(watchList);
                                                print('is not exist and added');
                                              }
                                              setState(() {});
                                            },
                                            child:
                                            firebaseMovieIdList.contains(IdList[index])?
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
                                    if(snapshot.data?.results?[index].backdropPath == null)
                                      Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image(image: AssetImage('assets/images/movie.jpg'),width: 140,
                                              height: 130,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              WatchListModel watchList=WatchListModel(
                                                movieId: snapshot.data!.results![index].id.toString(),
                                                imageUrl: snapshot.data!.results![index].backdropPath!,
                                                date: snapshot.data!.results![index].releaseDate!,
                                                title: snapshot.data!.results![index].title!,
                                                description: snapshot.data!.results![index].overview!,
                                              );
                                              if(firebaseMovieIdList.contains(IdList[index])){
                                                deleteWatchListFromFireStore(IdList[index]);
                                                print('is exist ');
                                              }else{
                                                addWatchListToFireStore(watchList);
                                                print('is not exist and added');
                                              }
                                              setState(() {});
                                            },
                                              child:
                                              firebaseMovieIdList.contains(IdList[index])?
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data!.results?[index].title??'No Name'}',
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              '${snapshot.data!.results?[index].releaseDate??'stil'}',
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
                                              '${snapshot.data!.results?[index].overview??'No Name'}',
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
                          itemCount: snapshot.data!.results!.length,
                        );
                      }),
                ],
              );
            } ,
          ),
        ),
      ),
    );
  }
}
