import 'package:flutter/material.dart';
import 'package:movie/models/search/Search.dart';
import 'package:movie/shared/api/api_manager.dart';
import 'package:movie/shared/constants/constants.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String data = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(18, 19, 18, 1.0),
        body: SingleChildScrollView(
          child: Column(
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
                  future: ApiManager.getSearch(data),
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
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              if(snapshot.data?.results?[index].backdropPath != null)
                              Image(
                                image: NetworkImage(
                                    '${BASE_IMAGE_URL + BASE_SIZE_IMAGE + snapshot.data!.results![index].backdropPath!}'),
                                width: 140,
                                height: 130,
                              ),
                              if(snapshot.data?.results?[index].backdropPath == null)
                                Image(image: AssetImage('assets/images/movie.jpg'),width: 140,
                                  height: 130,),
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
