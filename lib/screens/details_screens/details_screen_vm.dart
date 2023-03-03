import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movie/screens/details_screens/details_screen_state.dart';
import 'package:http/http.dart' as http;
import '../../models/details_screen/MoreLikeThis.dart';
import '../../models/details_screen/MovieDetails.dart';
import '../../shared/constants/constants.dart';

class DetailsScreenCubit extends Cubit<DetailsScreenStates>{

  DetailsScreenCubit():super(InitDetailsScreenState());
  static DetailsScreenCubit get(context)=>BlocProvider.of(context);
  MovieDetails? movieDetails;
  MoreLikeThis? moreLikeThis;

  Future<MovieDetails?> getMovieDetails(String movieId)async{
    emit(LoadingGetMovieDetailsState());
    Uri uri = Uri.https(BASE, '3/movie/$movieId',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      movieDetails = MovieDetails.fromJson(json);
      emit(SuccessGetMovieDetailsState());
      return movieDetails;
    }catch(error){
      print("error is: ${error}");
      emit(ErrorGetMovieDetailsState());
      throw error;
    }

  }

  Future<MoreLikeThis?> getMoreLikeThis(String movieId)async{
    emit(LoadingGetMoreLikeThisState());
    Uri uri = Uri.https(BASE, '/3/movie/$movieId/similar',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      moreLikeThis = MoreLikeThis.fromJson(json);
      emit(SuccessGetMoreLikeThisState());
      return moreLikeThis;
    }catch(error){
      print("error is: ${error}");
      emit(ErrorGetMoreLikeThisState());
      throw error;
    }

  }

}