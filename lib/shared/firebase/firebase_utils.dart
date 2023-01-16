import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/models/friebase_model/watch_list_model.dart';

CollectionReference<WatchListModel> getTaskCollection() {
  return
  FirebaseFirestore.instance.collection('watchList').withConverter<WatchListModel>(
      fromFirestore: (snapshot,option)=>WatchListModel.fromJson(snapshot.data()!),
      toFirestore: (watchlist,option)=>watchlist.toJson(),
  );
}



Future<void> addWatchListToFireStore(WatchListModel watchListModel) async {
  var collection= getTaskCollection();
  var docRef = collection.doc();
  watchListModel.id = docRef.id;
  return docRef.set(watchListModel);
}


Future<void> deleteWatchListFromFireStore(String movieId) async {
  var collection= getTaskCollection();
  return collection.doc(movieId).delete();
}

Stream<QuerySnapshot<WatchListModel>> getDataFromFireStore(){
  var data = getTaskCollection().get().asStream();
return data;

}