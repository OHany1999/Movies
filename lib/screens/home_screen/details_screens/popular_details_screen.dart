import 'package:flutter/material.dart';
import 'package:movie/models/home/MoreLikeThis.dart';
import 'package:movie/models/home/MovieDetails.dart';
import 'package:movie/models/home/home_screen_models/populer_model.dart';
import 'package:movie/shared/api/api_manager.dart';

import '../../../shared/constants/constants.dart';

class PopulerDetailsScreen extends StatelessWidget {
  static const String routeName = 'next';

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments as PopularModel;
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          '${arg.results.title}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      image: NetworkImage(
                          "${BASE_IMAGE_URL + BASE_SIZE_IMAGE + arg.results.backdropPath!}"),
                    ),
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
                        '${arg.results.title}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "${arg.results.releaseDate}",
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
                future: ApiManager.getMovieDetails(arg.results.id.toString()),
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
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment(-0.9, 0.5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                image: NetworkImage(
                                    '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + arg.results.posterPath!}'),
                                width: 150,
                                height: 180,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment(-0.89, -0.65),
                            child: InkWell(
                              onTap: () {
                                print('bookmark');
                              },
                              child: Image.asset('assets/images/bookmark.png'),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              // you can remove shrinkWrap
                              //and add container height and width insted
                              margin: EdgeInsets.only(bottom: 15,left: 8,right: 8),
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
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Text(
                                        "${snapshot.data!.genres?[index].name ?? "movie"}",
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
                                style: TextStyle(color: Colors.white,fontSize: 13),
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
                                Text(
                                  '${arg.results.voteAverage ?? 'rate'}',
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
              future: ApiManager.getMoreLikeThis(arg.results.id.toString()),
                builder: (context,snapshot){
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
                  return Container(
                    color: Color.fromRGBO(40, 42, 40, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10,top: 4),
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
                                return Container(
                                  // border width
                                  width: 120,
                                  margin: EdgeInsets.only(left: 10.0,bottom: 14),
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
                                                  "${BASE_IMAGE_URL + BASE_SIZE_IMAGE +
                                                      snapshot.data!.results![index]
                                                          .posterPath!}"),
                                              height: 135,
                                            ),
                                          ),
                                          Image.asset(
                                            'assets/images/bookmark.png',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Color.fromRGBO(
                                                255, 187, 59, 1.0),
                                          ),
                                          Text(
                                            '${snapshot.data?.results?[index]
                                                .voteAverage ?? 'rate'}',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${snapshot.data!.results?[index].title ??
                                            'nothing'}',
                                        style: TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${snapshot.data!.results?[index].releaseDate ??
                                            'still'}',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
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
        ),
      ),
    );
  }
}
