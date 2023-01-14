import 'package:flutter/material.dart';
import 'package:movie/models/MovieDetails.dart';
import 'package:movie/models/home_screen_models/populer_model.dart';
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
                                height: 200,
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
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 200,
                            width: 200,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 2 / 1,
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
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                    child: Text(
                                      "${snapshot.data!.genres?[index].name ?? "movie"}",
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(181, 180, 180, 1.0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
