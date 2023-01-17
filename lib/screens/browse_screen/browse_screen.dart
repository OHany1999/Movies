import 'package:flutter/material.dart';
import 'package:movie/models/browse/GenresSection.dart';
import 'package:movie/models/browse/browse_screen_model_for_navigator/id_model.dart';
import 'package:movie/screens/browse_screen/movie_category_screen.dart';
import 'package:movie/shared/api/api_manager.dart';

class BrowseScreen extends StatelessWidget {
  static const String routeName = 'browse';
  List<String> imageList = [
    'assets/images/Action.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/Comedy.jpeg',
    'assets/images/Horror.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/Fantasy.jpg',
    'assets/images/movie.jpg',
    'assets/images/Horror.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/Romance.jpg',
    'assets/images/star-wars.jpg',
    'assets/images/movie.jpg',
    'assets/images/Thriller.jpg',
    'assets/images/movie.jpg',
    'assets/images/Western.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
    'assets/images/movie.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  'Browse Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder<GenresSection>(
                future: ApiManager.getGenresSection(),
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
                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.genres!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 3,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            CategoryMoviesScreen.routeName,
                            arguments: IdModel(
                              snapshot.data!.genres![index].id.toString(),
                              snapshot.data!.genres![index].name!,
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: 5,
                            left: 5,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  imageList[index],
                                  fit: BoxFit.fill,
                                  width: 180,
                                  height: 100,
                                ),
                              ),
                              Text(
                                snapshot.data!.genres![index].name!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
