import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movie/screens/browse_screen/browse_screen_state.dart';
import 'package:http/http.dart' as http;
import '../../models/browse/GenresSection.dart';
import '../../shared/constants/constants.dart';

class BrowseCubit extends Cubit<BrowseStates>{

  BrowseCubit():super(InitBrowseState());
  static BrowseCubit get(context)=>BlocProvider.of(context);

  GenresSection? genresSection;

  Future<GenresSection?> getGenresSection()async{
    emit(LoadingBrowseState());
    Uri uri= Uri.https(BASE, '/3/genre/movie/list',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      genresSection = GenresSection.fromJson(json);
      emit(SuccessBrowseState());
      return genresSection;

    }catch(error){
      print("error is: ${error}");
      emit(ErrorBrowseState());
      throw error;
    }

  }
}