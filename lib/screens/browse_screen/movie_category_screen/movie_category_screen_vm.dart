import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movie/screens/browse_screen/movie_category_screen/movie_category_screen_state.dart';

import '../../../models/browse/Discover.dart';
import '../../../shared/constants/constants.dart';
import 'package:http/http.dart' as http;

class CategoryMoviesScreenCubit extends Cubit<CategoryMoviesScreenStates>{

  CategoryMoviesScreenCubit():super(InitCategoryMoviesScreenState());
  static CategoryMoviesScreenCubit get(context)=>BlocProvider.of(context);

  Discover? discover;

  Future<Discover?> getDiscover(String category_id)async{
    emit(LoadingCategoryMoviesScreenState());
    Uri uri= Uri.https(BASE, '/3/discover/movie',{
      'api_key':APIKEY,
      'with_genres':category_id,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      discover = Discover.fromJson(json);
      emit(SuccessCategoryMoviesScreenState());
      return discover;

    }catch(error){
      print("error is: ${error}");
      emit(ErrorCategoryMoviesScreenState());
      throw error;
    }

  }

}