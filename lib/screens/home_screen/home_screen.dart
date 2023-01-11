import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/NewReleases.dart';
import 'package:movie/models/Recommended.dart';
import 'package:movie/shared/constants/constants.dart';
import '../../models/Popular.dart';
import '../../shared/api/api_manager.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'firstHome';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Popular>(
      future: ApiManager.getPopular(),
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
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              CarouselSlider(
                items: snapshot.data!.results!
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          print('alllll');
                        },
                        child: Stack(
                          children: [
                            Image(
                              image: NetworkImage(
                                  "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + e.backdropPath!}"),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 180,
                              alignment: Alignment(0.5, -0.5),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/images/PlayBt.png"),
                              ),
                            ),
                            Container(
                              alignment: Alignment(0.5, 0.7),
                              child: Text(
                                e.title!,
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
                                e.releaseDate ?? 'still',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  alignment: Alignment(-0.9, 0.5),
                                  child: InkWell(
                                    onTap: () {
                                      print('poster');
                                    },
                                    child: Image(
                                      image: NetworkImage(
                                          '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + e.posterPath!}'),
                                      width: 150,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    print('bookmark');
                                  },
                                  child: Container(
                                    alignment: Alignment(-0.90,-0.65),
                                      child: Image.asset(
                                          'assets/images/bookmark.png')),
                                ),
                              ],
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
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              FutureBuilder<NewReleases>(
                future: ApiManager.getNewReleases(),
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
                            child: Image.asset('assets/images/movie.jpg'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.posterPath == null) {
                            return Image(
                                image: NetworkImage(
                                    "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.posterPath!}"));
                          } else {
                            return Image.asset('assets/images/movie.jpg');
                          }
                          //Text(snapshot.data!.title!,style: TextStyle(color: Colors.white),);
                          //
                        }),
                  );
                },
              ),
              FutureBuilder<Recommended>(
                future: ApiManager.getRecommended(),
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
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.results!.length,
                        itemBuilder: (context, index) {
                          return Image(
                            image: NetworkImage(
                                "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].posterPath!}"),
                          );
                        }),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
