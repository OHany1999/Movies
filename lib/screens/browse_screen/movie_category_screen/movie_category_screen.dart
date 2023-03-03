import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/models/browse/Discover.dart';
import 'package:movie/models/browse/browse_screen_model_for_navigator/id_model.dart';
import 'package:movie/models/main_details_Screen_model.dart';
import 'package:movie/models/search/Search.dart';
import 'package:movie/models/search/search_details_model.dart';
import 'package:movie/screens/browse_screen/movie_category_screen/movie_category_screen_state.dart';
import 'package:movie/screens/browse_screen/movie_category_screen/movie_category_screen_vm.dart';
import 'package:movie/screens/details_screens/details_screen.dart';
import 'package:movie/shared/constants/constants.dart';

import '../../../models/friebase_model/watch_list_model.dart';
import '../../../shared/firebase/firebase_utils.dart';

class CategoryMoviesScreen extends StatelessWidget {
  static const String routeName = 'movies_category';
  var get_gata_from_fireStore =getDataFromFireStore();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as IdModel;

    return BlocProvider(
      create: (context)=>CategoryMoviesScreenCubit()..getDiscover(args.catId) ,
      child: BlocConsumer<CategoryMoviesScreenCubit,CategoryMoviesScreenStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = CategoryMoviesScreenCubit.get(context);
          if(cubit.discover != null){
            var IdList = cubit.discover!.results!.map((docs) =>docs.id.toString()).toList();
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Text(
                    '${args.catName} Movies',
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
                    builder: (context,mainSnapshot){
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
                          ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context,
                                      DetailsScreen.routeName,
                                      arguments:DetailsModel(
                                        cubit.discover!.results![index].title??'nothing',
                                        cubit.discover!.results![index].backdropPath??'assets/images/movie.jpg',
                                        cubit.discover!.results![index].releaseDate??'No date',
                                        cubit.discover!.results![index].id.toString(),
                                        cubit.discover!.results![index].posterPath??'assets/images/movie.jpg',
                                        cubit.discover!.results![index].voteAverage.toString(),
                                      )
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      if (cubit.discover!.results?[index].backdropPath !=
                                          null)
                                        Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(30),
                                              child: Image(
                                                image: NetworkImage(
                                                    '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + cubit.discover!.results![index].backdropPath!}'),
                                                width: 140,
                                                height: 130,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                WatchListModel watchList=WatchListModel(
                                                  movieId: cubit.discover!.results![index].id.toString(),
                                                  imageUrl: cubit.discover!.results![index].backdropPath!,
                                                  date: cubit.discover!.results![index].releaseDate??'assets/images/movie.jpg',
                                                  title: cubit.discover!.results![index].title??'nothing',
                                                  description: cubit.discover!.results![index].overview??'nothing',
                                                  posterPath: cubit.discover!.results![index].posterPath??'assets/images/movie.jpg',
                                                  voteAverage: cubit.discover!.results![index].voteAverage.toString(),
                                                );
                                                if(firebaseMovieIdList.contains(IdList[index])){
                                                  deleteWatchListFromFireStore(IdList[index]);
                                                  print('is exist ');
                                                }else{
                                                  addWatchListToFireStore(watchList);
                                                  print('is not exist and added');
                                                }
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
                                      if (cubit.discover!.results?[index].backdropPath ==
                                          null)
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
                                                WatchListModel watchList=WatchListModel(
                                                  movieId: cubit.discover!.results![index].id.toString(),
                                                  imageUrl: cubit.discover!.results![index].backdropPath??'assets/images/movie.jpg',
                                                  date: cubit.discover!.results![index].releaseDate??'nothing',
                                                  title: cubit.discover!.results![index].title??'nothing',
                                                  description: cubit.discover!.results![index].overview??'nothing',
                                                  posterPath: cubit.discover!.results![index].posterPath??'assets/images/movie.jpg',
                                                  voteAverage: cubit.discover!.results![index].voteAverage.toString(),
                                                );
                                                if(firebaseMovieIdList.contains(IdList[index])){
                                                  deleteWatchListFromFireStore(IdList[index]);
                                                  print('is exist ');
                                                }else{
                                                  addWatchListToFireStore(watchList);
                                                  print('is not exist and added');
                                                }
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${cubit.discover!.results?[index].title ?? 'No Name'}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                '${cubit.discover!.results?[index].releaseDate ?? 'stil'}',
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
                                                '${cubit.discover!.results?[index].overview ?? 'No Name'}',
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
                            itemCount: cubit.discover!.results!.length,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}
