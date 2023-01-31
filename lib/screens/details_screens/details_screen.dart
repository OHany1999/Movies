import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/details_screen/MoreLikeThis.dart';
import 'package:movie/models/details_screen/MovieDetails.dart';
import 'package:movie/models/home/home_screen_models_for_navigate/new_releases_model.dart';
import 'package:movie/models/main_details_Screen_model.dart';
import 'package:movie/screens/details_screens/details_screen.dart';
import 'package:movie/screens/home_screen/home_screen.dart';
import 'package:movie/shared/api/api_manager.dart';

import '../../../shared/constants/constants.dart';
import '../../home_layout/home_layout.dart';
import '../../models/friebase_model/watch_list_model.dart';
import '../../shared/firebase/firebase_utils.dart';

class DetailsScreen extends StatefulWidget {
  static const String routeName = 'DetailsScreen';

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments as DetailsModel;
    var get_gata_from_fireStore =getDataFromFireStore();
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          '${arg.title}',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, HomeLayout.routeName);
            },
            icon: Icon(Icons.home),),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: StreamBuilder<QuerySnapshot<WatchListModel>>(
          stream: get_gata_from_fireStore,
          builder: (context,MainSnapshot){
            if (MainSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Container());
            }
            if (MainSnapshot.hasError) {
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
            List<WatchListModel> firebaseList = MainSnapshot.data!.docs.map((event) => event.data()).toList();
            var firebaseMovieIdList = firebaseList.map((docs) => docs.movieId).toList();
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if(arg.backgroundImage != 'assets/images/movie.jpg')
                          Image(
                            image: NetworkImage(
                                "${BASE_IMAGE_URL + BASE_SIZE_IMAGE +
                                    arg.backgroundImage}"),
                          ),
                        Image.asset('assets/images/PlayBt.png'),
                        if(arg.backgroundImage == 'assets/images/movie.jpg')
                          Image.asset('assets/images/movie.jpg'),
                        Image.asset('assets/images/PlayBt.png'),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${arg.title}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "${arg.releaseDate}",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<MovieDetails>(
                    future: ApiManager.getMovieDetails(arg.movieId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
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
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                if(arg.posterImage != 'assets/images/movie.jpg')
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image(
                                    image: NetworkImage(
                                        '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + arg.posterImage}'),
                                    width: 130,
                                    height: 180,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                if(arg.posterImage == 'assets/images/movie.jpg')
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset('assets/images/movie.jpg', width: 130,
                                    height: 180,
                                    fit: BoxFit.fill,),
                                ),
                                InkWell(
                                  onTap: () {
                                    WatchListModel watchList=WatchListModel(
                                      movieId: snapshot.data!.id.toString(),
                                      imageUrl: snapshot.data!.backdropPath??'assets/images/movie.jpg',
                                      date: snapshot.data!.releaseDate!,
                                      title: snapshot.data!.title!,
                                      description: snapshot.data!.overview!,
                                      posterPath: snapshot.data!.posterPath??'assets/images/movie.jpg',
                                      voteAverage: snapshot.data!.voteAverage.toString(),
                                    );
                                    if(firebaseMovieIdList.contains(snapshot.data!.id.toString())){
                                      deleteWatchListFromFireStore(snapshot.data!.id.toString());
                                      print('is exist ');
                                    }else{
                                      addWatchListToFireStore(watchList);
                                      print('is not exist and added');
                                    }

                                    setState(() {});
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: firebaseMovieIdList.contains(snapshot.data!.id.toString())?
                                    Image.asset('assets/images/bookmark2.png',):
                                    Image.asset('assets/images/bookmark.png',),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  // you can remove shrinkWrap
                                  //and add container height and width insted
                                  margin: EdgeInsets.only(
                                      bottom: 15, left: 8, right: 8),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: 2.6 / 1,
                                      ),
                                      itemCount: snapshot.data!.genres!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    181, 180, 180, 1.0),
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                  5)),
                                          child: Text(
                                            "${snapshot.data!.genres?[index].name ??
                                                "movie"}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                              Color.fromRGBO(181, 180, 180, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    '${snapshot.data!.overview}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Color.fromRGBO(255, 187, 59, 1.0),
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      '${arg.voteAverage.substring(0,1)}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                SizedBox(height: 10.0,),
                FutureBuilder<MoreLikeThis>(
                    future: ApiManager.getMoreLikeThis(arg.movieId),
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
                        color: Color.fromRGBO(40, 42, 40, 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 4),
                              child: Text(
                                'More Like This',
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
                              height: 220,
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
                                            snapshot.data!.results![index].title!,
                                            snapshot.data!.results![index].backdropPath!,
                                            snapshot.data!.results![index].releaseDate!,
                                            snapshot.data!.results![index].id.toString(),
                                            snapshot.data!.results![index].posterPath!,
                                            snapshot.data!.results![index].voteAverage.toString(),
                                          )
                                          ,
                                        );
                                      },
                                      child: Container(
                                        // border width
                                        width: 115,
                                        margin: EdgeInsets.only(
                                            left: 10.0, bottom: 14),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromRGBO(52, 53, 52, 1.0),
                                          ),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                          color: Color.fromRGBO(52, 53, 52, 1.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        "${BASE_IMAGE_URL +
                                                            BASE_SIZE_IMAGE +
                                                            snapshot.data!
                                                                .results![index]
                                                                .posterPath!}"),
                                                    width: double.infinity,
                                                    height: 130,
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
                                                      posterPath: snapshot.data!.results![index].posterPath!,
                                                      voteAverage: snapshot.data!.results![index].voteAverage.toString(),
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
                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                SizedBox(width: 10,),
                                                Icon(
                                                  Icons.star,
                                                  color: Color.fromRGBO(
                                                      255, 187, 59, 1.0),
                                                ),
                                                SizedBox(width: 5,),
                                                Text('${snapshot.data?.results?[index].voteAverage ?? 'rate'}'.substring(0,1),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3,),
                                            Text(
                                              '${snapshot.data!.results?[index]
                                                  .title ??
                                                  'nothing'}',
                                              style: TextStyle(color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 3,),
                                            Text(
                                              '${snapshot.data!.results?[index]
                                                  .releaseDate ??
                                                  'still'}',
                                              style: TextStyle(color: Colors.white),
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
                    }
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
