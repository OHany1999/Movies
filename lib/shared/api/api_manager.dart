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

  static Future<Popular> getPopular()async{
    Uri uri= Uri.https(BASE, '/3/movie/popular',{
      'api_key':APIKEY,
      'language': 'en-US',
      'page':'1'
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      Popular popular = Popular.fromJson(json);
      return popular;

    }catch(error){
      print("error is: ${error}");
      throw error;
    }

  }

  static Future<NewReleases> getNewReleases()async{
    Uri uri= Uri.https(BASE, '/3/movie/now_playing',{
      'api_key':APIKEY,

    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      NewReleases newReleases = NewReleases.fromJson(json);
      return newReleases;


    }catch(error){
      print("error is: ${error}");
      throw error;
    }

  }

  static Future<Recommended> getRecommended()async{
    Uri uri= Uri.https(BASE, '/3/movie/top_rated',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      Recommended recommended = Recommended.fromJson(json);
      return recommended;


    }catch(error){
      print("error is: ${error}");
      throw error;
    }

  }


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

  static Future<Search> getSearch(String Query)async{
    Uri uri = Uri.https(BASE,'/3/search/movie',{
      'api_key':APIKEY,
      'query': Query,
    });
    Response sources = await http.get(uri);
    var json = jsonDecode(sources.body);
    Search search = Search.fromJson(json);
    return search;

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