import '../home/Recommended.dart';

class WatchListModel {
  String movieId;
  String imageUrl;
  String date;
  String title;
  String description;

  WatchListModel({
    this.movieId='',
    required this.imageUrl,
    required this.date,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'imageUrl': imageUrl,
      'date': date,
      'title': title,
      'description': description,
    };
  }

  WatchListModel.fromJson(Map<String, dynamic> json)
      : this(
          movieId: json['movieId'],
          imageUrl: json['imageUrl'],
          date: json['date'],
          title: json['title'],
          description: json['description'],
        );
}
