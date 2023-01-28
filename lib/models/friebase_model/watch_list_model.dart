import '../home/Recommended.dart';

class WatchListModel {
  String movieId;
  String imageUrl;
  String date;
  String title;
  String description;
  String posterPath;
  String voteAverage;

  WatchListModel({
    this.movieId='',
    required this.imageUrl,
    required this.date,
    required this.title,
    required this.description,
    required this.posterPath,
    required this.voteAverage,
  });

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'imageUrl': imageUrl,
      'date': date,
      'title': title,
      'description': description,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
    };
  }

  WatchListModel.fromJson(Map<String, dynamic> json)
      : this(
          movieId: json['movieId'],
          imageUrl: json['imageUrl'],
          date: json['date'],
          title: json['title'],
          description: json['description'],
          posterPath: json['posterPath'],
          voteAverage: json['voteAverage'],
        );
}
