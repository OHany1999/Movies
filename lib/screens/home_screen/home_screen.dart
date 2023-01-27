import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/friebase_model/watch_list_model.dart';
import 'package:movie/models/home/NewReleases.dart';
import 'package:movie/models/home/Recommended.dart';
import 'package:movie/shared/constants/constants.dart';
import 'package:movie/shared/firebase/firebase_utils.dart';
import '../../models/home/Popular.dart';
import '../../models/main_details_Screen_model.dart';
import '../../shared/api/api_manager.dart';
import '../details_screens/details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'firstHome';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool mark = false;
  var get_gata_from_fireStore =getDataFromFireStore();
  var getPopular =ApiManager.getPopular();
  var getNewReleases =ApiManager.getNewReleases();
  var getRecommended =ApiManager.getRecommended();

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: StreamBuilder<QuerySnapshot<WatchListModel>>(
            stream: get_gata_from_fireStore,
            builder: (context, mainSnapshot) {
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
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<Popular>(
                    future: getPopular,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: EdgeInsets.only(top: 350),
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
                      return CarouselSlider(
                        items: snapshot.data!.results!
                            .map(
                              (results) => InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, DetailsScreen.routeName,
                                      arguments: DetailsModel(
                                        results.title!,
                                        results.backdropPath!,
                                        results.releaseDate!,
                                        results.id.toString(),
                                        results.posterPath!,
                                        results.voteAverage.toString(),
                                      ));
                                  print('alllll');
                                },
                                child: Stack(
                                  children: [
                                    if (results.backdropPath != null)
                                      Image(
                                        image: NetworkImage(
                                            "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + results.backdropPath!}"),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 180,
                                        alignment: Alignment(0.5, -0.5),
                                      ),
                                    if (results.backdropPath == null)
                                      Image.asset('assets/images/movie.jpg'),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/PlayBt.png"),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment(0.5, 0.7),
                                      child: Text(
                                        results.title!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment(0.5, 0.9),
                                      child: Text(
                                        results.releaseDate ?? 'still',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 70,left: 10),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  DetailsScreen.routeName,
                                                  arguments: DetailsModel(
                                                    results.title!,
                                                    results.backdropPath!,
                                                    results.releaseDate!,
                                                    results.id.toString(),
                                                    results.posterPath!,
                                                    results.voteAverage
                                                        .toString(),
                                                  ));
                                              print('poster');
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image(
                                                image: NetworkImage(
                                                    '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + results.posterPath!}'),
                                                width: 130,
                                                height: 180,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              WatchListModel watchList=WatchListModel(
                                                movieId: results.id.toString(),
                                                imageUrl: results.backdropPath!,
                                                date: results.releaseDate!,
                                                title: results.title!,
                                                description: results.overview!,
                                              );
                                              if(firebaseMovieIdList.contains(results.id.toString())){
                                                deleteWatchListFromFireStore(results.id.toString());
                                                print('is exist ');
                                              }else{
                                                addWatchListToFireStore(watchList);
                                                print('is not exist and added');
                                              }

                                              setState(() {});
                                            },
                                            child:
                                            firebaseMovieIdList.contains(results.id.toString())?
                                            Image.asset('assets/images/bookmark2.png',):
                                            Image.asset('assets/images/bookmark.png',),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          height: 250,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                        ),
                      );
                    },
                  ),
                  FutureBuilder<NewReleases>(
                    future: getNewReleases,
                    builder: (context, snapshot) {
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
                      var IdList = snapshot.data!.results!.map((docs) =>docs.id.toString()).toList();
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        color: Color.fromRGBO(40, 42, 40, 1.0),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              alignment: Alignment(-0.90, 0.7),
                              height: 30,
                              child: Text(
                                'New Releases ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              height: 130,
                              child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.results!.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, DetailsScreen.routeName,
                                            arguments: DetailsModel(
                                              snapshot
                                                  .data!.results![index].title!,
                                              snapshot.data!.results![index]
                                                  .backdropPath!,
                                              snapshot.data!.results![index]
                                                  .releaseDate!,
                                              snapshot.data!.results![index].id
                                                  .toString(),
                                              snapshot.data!.results![index]
                                                  .posterPath!,
                                              snapshot.data!.results![index]
                                                  .voteAverage
                                                  .toString(),
                                            ));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image(
                                                image: NetworkImage(
                                                    "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].posterPath!}"),
                                                height: 120,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
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
                                              Image.asset('assets/images/bookmark2.png',):
                                              Image.asset('assets/images/bookmark.png',),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  FutureBuilder<Recommended>(
                    future: getRecommended,
                    builder: (context, snapshot) {
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
                      var IdList = snapshot.data!.results!.map((docs) =>docs.id.toString()).toList();
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        color: Color.fromRGBO(40, 42, 40, 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                'Recommended',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              // border with all
                              height: ScreenSize.height - 580,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.results!.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, DetailsScreen.routeName,
                                            arguments: DetailsModel(
                                              snapshot
                                                  .data!.results![index].title!,
                                              snapshot.data!.results![index]
                                                  .backdropPath!,
                                              snapshot.data!.results![index]
                                                  .releaseDate!,
                                              snapshot.data!.results![index].id
                                                  .toString(),
                                              snapshot.data!.results![index]
                                                  .posterPath!,
                                              snapshot.data!.results![index]
                                                  .voteAverage
                                                  .toString(),
                                            ));
                                      },
                                      child: Container(
                                        // border width
                                        width: 115,
                                        margin: EdgeInsets.only(
                                            left: 10.0, bottom: 14),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Color.fromRGBO(52, 53, 52, 1.0),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color:
                                              Color.fromRGBO(52, 53, 52, 1.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].posterPath!}"),
                                                    height: 130,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
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
                                                  Image.asset('assets/images/bookmark2.png',):
                                                  Image.asset('assets/images/bookmark.png',),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Color.fromRGBO(
                                                      255, 187, 59, 1.0),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${snapshot.data?.results?[index].voteAverage ?? 'rate'}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              '${snapshot.data!.results?[index].title ?? 'nothing'}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${snapshot.data!.results?[index].releaseDate ?? 'still'}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
