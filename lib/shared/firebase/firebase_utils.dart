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
  var docRef = collection.doc(watchListModel.movieId);
  return docRef.set(watchListModel);
}


Future<void> deleteWatchListFromFireStore(String docId) async {
  var collection= getTaskCollection();
  return collection.doc(docId).delete();
}

Stream<QuerySnapshot<WatchListModel>> getDataFromFireStore(){
  var data = getTaskCollection().snapshots();
  return data;

}