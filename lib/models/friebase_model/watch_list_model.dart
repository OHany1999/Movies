class WatchListModel {
  String id;
  String movieId;
  bool isMarked;
  String imageUrl;
  String date;
  String title;
  String description;

  WatchListModel(
      {this.id = '',
        required this.movieId,
      this.isMarked = false,
      required this.imageUrl,
      required this.date,
      required this.title,
      required this.description});

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'movieId': movieId,
      'isMarked': isMarked,
      'imageUrl': imageUrl,
      'date': date,
      'title': title,
      'description': description,
    };
  }

  WatchListModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          movieId: json['movieId'],
          isMarked: json['isMarked'],
          imageUrl: json['imageUrl'],
          date: json['date'],
          title: json['title'],
          description: json['description'],
        );
}
