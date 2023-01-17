import 'package:flutter/material.dart';
import 'package:movie/models/browse/Discover.dart';
import 'package:movie/models/browse/browse_screen_model_for_navigator/id_model.dart';
import 'package:movie/models/main_details_Screen_model.dart';
import 'package:movie/models/search/Search.dart';
import 'package:movie/models/search/search_details_model.dart';
import 'package:movie/screens/details_screens/details_screen.dart';
import 'package:movie/shared/api/api_manager.dart';
import 'package:movie/shared/constants/constants.dart';

class CategoryMoviesScreen extends StatelessWidget {
  static const String routeName = 'movies_category';

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as IdModel;
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
          child: Column(
            children: [
              FutureBuilder<Discover>(
                  future: ApiManager.getDiscover(args.catId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: EdgeInsets.only(top: 300),
                        child: Center(child: CircularProgressIndicator()),
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
                                if (snapshot
                                        .data?.results?[index].backdropPath !=
                                    null)
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
                                      Container(
                                          margin: EdgeInsets.only(top: 25),
                                          child: Image.asset(
                                              'assets/images/bookmark.png')),
                                    ],
                                  ),
                                if (snapshot
                                        .data?.results?[index].backdropPath ==
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
                                      Container(
                                          margin: EdgeInsets.only(top: 18),
                                          child: Image.asset(
                                              'assets/images/bookmark.png')),
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
                                          '${snapshot.data!.results?[index].title ?? 'No Name'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          '${snapshot.data!.results?[index].releaseDate ?? 'stil'}',
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
                                          '${snapshot.data!.results?[index].overview ?? 'No Name'}',
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
          ),
        ),
      ),
    );
  }
}
