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
  var get_gata_from_fireStore = getDataFromFireStore();
  var getPopular = ApiManager.getPopular();
  var getNewReleases = ApiManager.getNewReleases();
  var getRecommended = ApiManager.getRecommended();

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
              List<WatchListModel> firebaseList =
                  mainSnapshot.data!.docs.map((event) => event.data()).toList();
              var firebaseMovieIdList =
                  firebaseList.map((docs) => docs.movieId).toList();
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
                                        results.title ?? 'nothing',
                                        results.backdropPath ??
                                            'assets/images/movie.jpg',
                                        results.releaseDate ?? 'No date',
                                        results.id.toString(),
                                        results.posterPath ??
                                            'assets/images/movie.jpg',
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
                                      margin:
                                          EdgeInsets.only(left: 220, top: 50),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            results.title!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            results.releaseDate ?? 'still',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (results.posterPath != null)
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 70, left: 10),
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    DetailsScreen.routeName,
                                                    arguments: DetailsModel(
                                                      results.title ??
                                                          'nothing',
                                                      results.backdropPath ??
                                                          'assets/images/movie.jpg',
                                                      results.releaseDate ??
                                                          'No date',
                                                      results.id.toString(),
                                                      results.posterPath ??
                                                          'assets/images/movie.jpg',
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
                                                WatchListModel watchList =
                                                    WatchListModel(
                                                  movieId:
                                                      results.id.toString(),
                                                  imageUrl: results
                                                          .backdropPath ??
                                                      'assets/images/movie.jpg',
                                                  date: results.releaseDate ??
                                                      'No date',
                                                  title: results.title ??
                                                      'nothing',
                                                  description:
                                                      results.overview ??
                                                          'nothing',
                                                  posterPath: results
                                                          .posterPath ??
                                                      'assets/images/movie.jpg',
                                                  voteAverage: results
                                                      .voteAverage
                                                      .toString(),
                                                );
                                                if (firebaseMovieIdList
                                                    .contains(results.id
                                                        .toString())) {
                                                  deleteWatchListFromFireStore(
                                                      results.id.toString());
                                                  print('is exist ');
                                                } else {
                                                  addWatchListToFireStore(
                                                      watchList);
                                                  print(
                                                      'is not exist and added');
                                                }

                                                setState(() {});
                                              },
                                              child:
                                                  firebaseMovieIdList.contains(
                                                          results.id.toString())
                                                      ? Image.asset(
                                                          'assets/images/bookmark2.png',
                                                        )
                                                      : Image.asset(
                                                          'assets/images/bookmark.png',
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (results.posterPath == null)
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 70, left: 10),
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    DetailsScreen.routeName,
                                                    arguments: DetailsModel(
                                                      results.title ??
                                                          'nothing',
                                                      results.backdropPath ??
                                                          'assets/images/movie.jpg',
                                                      results.releaseDate ??
                                                          'No date',
                                                      results.id.toString(),
                                                      results.posterPath ??
                                                          'assets/images/movie.jpg',
                                                      results.voteAverage
                                                          .toString(),
                                                    ));
                                                print('poster');
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/movie.jpg'),
                                                  width: 130,
                                                  height: 180,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                WatchListModel watchList =
                                                    WatchListModel(
                                                  movieId:
                                                      results.id.toString(),
                                                  imageUrl: results
                                                          .backdropPath ??
                                                      'assets/images/movie.jpg',
                                                  date: results.releaseDate ??
                                                      'No date',
                                                  title: results.title ??
                                                      'nothing',
                                                  description:
                                                      results.overview ??
                                                          'nothing',
                                                  posterPath: results
                                                          .posterPath ??
                                                      'assets/images/movie.jpg',
                                                  voteAverage: results
                                                      .voteAverage
                                                      .toString(),
                                                );
                                                if (firebaseMovieIdList
                                                    .contains(results.id
                                                        .toString())) {
                                                  deleteWatchListFromFireStore(
                                                      results.id.toString());
                                                  print('is exist ');
                                                } else {
                                                  addWatchListToFireStore(
                                                      watchList);
                                                  print(
                                                      'is not exist and added');
                                                }

                                                setState(() {});
                                              },
                                              child:
                                                  firebaseMovieIdList.contains(
                                                          results.id.toString())
                                                      ? Image.asset(
                                                          'assets/images/bookmark2.png',
                                                        )
                                                      : Image.asset(
                                                          'assets/images/bookmark.png',
                                                        ),
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
                          height: ScreenSize.height * .29,
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
                      var IdList = snapshot.data!.results!
                          .map((docs) => docs.id.toString())
                          .toList();
                      var WidgetHeight = ScreenSize.height * .17;
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
                              height: WidgetHeight,
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
                                              snapshot.data!.results![index]
                                                      .title ??
                                                  'nothing',
                                              snapshot.data!.results![index]
                                                      .backdropPath ??
                                                  'assets/images/movie.jpg',
                                              snapshot.data!.results![index]
                                                      .releaseDate ??
                                                  'nothing',
                                              snapshot.data!.results![index].id
                                                  .toString(),
                                              snapshot.data!.results![index]
                                                      .posterPath ??
                                                  'assets/images/movie.jpg',
                                              snapshot.data!.results![index]
                                                  .voteAverage
                                                  .toString(),
                                            ));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Stack(
                                          children: [
                                            if (snapshot.data!.results![index]
                                                    .posterPath !=
                                                null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image(
                                                  image: NetworkImage(
                                                      "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].posterPath!}"),
                                                  height: WidgetHeight * .94,
                                                  width: 100,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            if (snapshot.data!.results![index]
                                                    .posterPath ==
                                                null)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/movie.jpg'),
                                                  height: WidgetHeight * .94,
                                                  width: 100,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            InkWell(
                                              onTap: () {
                                                WatchListModel watchList =
                                                    WatchListModel(
                                                  movieId: snapshot
                                                      .data!.results![index].id
                                                      .toString(),
                                                  imageUrl: snapshot
                                                          .data!
                                                          .results![index]
                                                          .backdropPath ??
                                                      'assets/images/movie.jpg',
                                                  date: snapshot
                                                          .data!
                                                          .results![index]
                                                          .releaseDate ??
                                                      'No date',
                                                  title: snapshot
                                                          .data!
                                                          .results![index]
                                                          .title ??
                                                      'nothing',
                                                  description: snapshot
                                                          .data!
                                                          .results![index]
                                                          .overview ??
                                                      'nothing',
                                                  posterPath: snapshot
                                                          .data!
                                                          .results![index]
                                                          .posterPath ??
                                                      'assets/images/movie.jpg',
                                                  voteAverage: snapshot
                                                      .data!
                                                      .results![index]
                                                      .voteAverage
                                                      .toString(),
                                                );
                                                if (firebaseMovieIdList
                                                    .contains(IdList[index])) {
                                                  deleteWatchListFromFireStore(
                                                      IdList[index]);
                                                  print('is exist ');
                                                } else {
                                                  addWatchListToFireStore(
                                                      watchList);
                                                  print(
                                                      'is not exist and added');
                                                }

                                                setState(() {});
                                              },
                                              child: firebaseMovieIdList
                                                      .contains(IdList[index])
                                                  ? Image.asset(
                                                      'assets/images/bookmark2.png',
                                                    )
                                                  : Image.asset(
                                                      'assets/images/bookmark.png',
                                                    ),
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
                      var IdList = snapshot.data!.results!
                          .map((docs) => docs.id.toString())
                          .toList();
                      var widgetHeight = ScreenSize.height * .28;
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
                              height: widgetHeight,
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
                                              snapshot.data!.results![index]
                                                      .title ??
                                                  'nothing',
                                              snapshot.data!.results![index]
                                                      .backdropPath ??
                                                  'assets/images/movie.jpg',
                                              snapshot.data!.results![index]
                                                      .releaseDate ??
                                                  'nothing',
                                              snapshot.data!.results![index].id
                                                  .toString(),
                                              snapshot.data!.results![index]
                                                      .posterPath ??
                                                  'assets/images/movie.jpg',
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
                                                if (snapshot
                                                        .data!
                                                        .results![index]
                                                        .posterPath !=
                                                    null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].posterPath!}"),
                                                      height:
                                                          widgetHeight * .55,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                if (snapshot
                                                        .data!
                                                        .results![index]
                                                        .posterPath ==
                                                    null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image(
                                                      image: AssetImage(
                                                          'assets/images/movie.jpg'),
                                                      height:
                                                          widgetHeight * .55,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                InkWell(
                                                  onTap: () {
                                                    WatchListModel watchList =
                                                        WatchListModel(
                                                      movieId: snapshot.data!
                                                          .results![index].id
                                                          .toString(),
                                                      imageUrl: snapshot
                                                              .data!
                                                              .results![index]
                                                              .backdropPath ??
                                                          'assets/images/movie.jpg',
                                                      date: snapshot
                                                              .data!
                                                              .results![index]
                                                              .releaseDate ??
                                                          'No date',
                                                      title: snapshot
                                                              .data!
                                                              .results![index]
                                                              .title ??
                                                          'nothing',
                                                      description: snapshot
                                                              .data!
                                                              .results![index]
                                                              .overview ??
                                                          'nothing',
                                                      posterPath: snapshot
                                                              .data!
                                                              .results![index]
                                                              .posterPath ??
                                                          'assets/images/movie.jpg',
                                                      voteAverage: snapshot
                                                          .data!
                                                          .results![index]
                                                          .voteAverage
                                                          .toString(),
                                                    );
                                                    if (firebaseMovieIdList
                                                        .contains(
                                                            IdList[index])) {
                                                      deleteWatchListFromFireStore(
                                                          IdList[index]);
                                                      print('is exist ');
                                                    } else {
                                                      addWatchListToFireStore(
                                                          watchList);
                                                      print(
                                                          'is not exist and added');
                                                    }

                                                    setState(() {});
                                                  },
                                                  child: firebaseMovieIdList
                                                          .contains(
                                                              IdList[index])
                                                      ? Image.asset(
                                                          'assets/images/bookmark2.png',
                                                        )
                                                      : Image.asset(
                                                          'assets/images/bookmark.png',
                                                        ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
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
                                                  width: 8,
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
