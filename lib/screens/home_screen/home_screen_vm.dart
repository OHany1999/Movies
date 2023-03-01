import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:movie/screens/home_screen/home_screen_state.dart';
import 'package:http/http.dart' as http;
import 'package:movie/shared/firebase/firebase_utils.dart';
import '../../models/friebase_model/watch_list_model.dart';
import '../../models/home/NewReleases.dart';
import '../../models/home/Popular.dart';
import '../../models/home/Recommended.dart';
import '../../shared/constants/constants.dart';


class HomeCubit extends Cubit<HomeStates>{

  HomeCubit():super(InitHomeState());

  static HomeCubit get(context)=>BlocProvider.of(context);
  Popular? popular;
  NewReleases? newReleases;
  Recommended? recommended;


  Future<Popular?> getPopular()async{
    Uri uri= Uri.https(BASE, '/3/movie/popular',{
      'api_key':APIKEY,
      'language': 'en-US',
      'page':'1'
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      popular = Popular.fromJson(json);
      if(newReleases != null && popular!=null && recommended !=null){
        emit(SuccessGetPopularState());
      }
      return popular;
    }catch(error){
      print("error is: ${error}");
      emit(ErrorGetPopularState());
      throw error;
    }
  }

  Future<NewReleases?> getNewReleases()async{
    Uri uri= Uri.https(BASE, '/3/movie/now_playing',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      newReleases = NewReleases.fromJson(json);
      if(newReleases != null && popular!=null && recommended !=null){
        emit(SuccessGetNewReleasesState());
      }
      return newReleases;

    }catch(error){
      print("error is: ${error}");
      emit(ErrorGetNewReleasesState());
      throw error;
    }

  }


  Future<Recommended?> getRecommended()async{
    Uri uri= Uri.https(BASE, '/3/movie/top_rated',{
      'api_key':APIKEY,
    });
    Response sources = await http.get(uri);
    try{
      var json = jsonDecode(sources.body);
      recommended = Recommended.fromJson(json);
      if(newReleases != null && popular!=null && recommended !=null){
        emit(SuccessGetRecommendedState());
      }
      return recommended;

    }catch(error){
      print("error is: ${error}");
      emit(ErrorGetRecommendedState());
      throw error;
    }
  }

// Future<WatchListModel?> getDataFromFireStoreFor()async{
//   var myData =  await getTaskCollection().get();
//   watchListModel = myData.docs.map((e) => e.data()).toList();
//   if(newReleases != null && popular!=null && recommended !=null && watchListModel != null){
//     emit(SuccessGetFromStoreToHomeScreenState());
//   }
// }


// عشان تعمل function تخليها تتاكد منهم كلهم لازم تدلها وقت لانها هتشتغل اسرع منهم
// ف مش هتلحق التغيرات اللي بتحصل معاهم
//   void all() async {
//     await Future.delayed(Duration(seconds: 3));
//
//     if(popular != null && newReleases != null){
//       emit(AllSuccessState());
//     }else{
//       emit(AllLoadingState());
//     }
//   }


}