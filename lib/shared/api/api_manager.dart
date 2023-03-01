import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:movie/models/browse/Discover.dart';
import 'package:movie/models/browse/GenresSection.dart';
import 'package:movie/models/details_screen/MoreLikeThis.dart';
import 'package:movie/models/home/NewReleases.dart';
import 'package:movie/models/home/Recommended.dart';
import '../../models/details_screen/MovieDetails.dart';
import '../../models/home/Popular.dart';
import '../../models/search/Search.dart';
import '../constants/constants.dart';


class ApiManager{



  static Future<MovieDetails> getMovieDetails(String movieId)async{
    Uri uri = Uri.https(BASE, '3/movie/$movieId',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    var json = jsonDecode(sources.body);
    MovieDetails movieDetails = MovieDetails.fromJson(json);
    return movieDetails;

  }

  static Future<MoreLikeThis> getMoreLikeThis(String movieId)async{
    Uri uri = Uri.https(BASE, '/3/movie/$movieId/similar',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    var json = jsonDecode(sources.body);
    MoreLikeThis moreLikeThis = MoreLikeThis.fromJson(json);
    return moreLikeThis;

  }




  static Future<GenresSection> getGenresSection()async{
    Uri uri= Uri.https(BASE, '/3/genre/movie/list',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      GenresSection genresSection = GenresSection.fromJson(json);
      return genresSection;


    }catch(error){
      print("error is: ${error}");
      throw error;
    }

  }

  static Future<Discover> getDiscover(String category_id)async{
    Uri uri= Uri.https(BASE, '/3/discover/movie',{
      'api_key':APIKEY,
      'with_genres':category_id,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      Discover discover = Discover.fromJson(json);
      return discover;


    }catch(error){
      print("error is: ${error}");
      throw error;
    }

  }
}