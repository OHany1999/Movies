import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movie/screens/search_screen/search_screen_state.dart';
import 'package:http/http.dart' as http;
import '../../models/search/Search.dart';
import '../../shared/constants/constants.dart';

class SearchCubit extends Cubit<SearchStates>{

  SearchCubit():super(InitSearchState());
  static SearchCubit get(context)=>BlocProvider.of(context);
  Search? search;
  String data = '';



  Future<Search?> getSearch()async{
    emit(LoadingSearchState());
    Uri uri = Uri.https(BASE,'/3/search/movie',{
      'api_key':APIKEY,
      'query': data,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      search = Search.fromJson(json);
      emit(SuccessSearchState());
      print(search);
      return search;
    }catch(error){
      emit(ErrorSearchState());
      throw error;
    }
  }

  void ChangeData(String text){
    data = text;
    emit(ChangeState());
  }


}