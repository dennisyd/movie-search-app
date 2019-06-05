import 'package:meta/meta.dart';

class Movie {
  // class variables
  String title, posterPath, id, overview;
  bool favored, isExpanded;

  // constructor
  Movie({
    @required this.title,
    @required this.posterPath,
    @required this.id,
    @required this.overview,
    this.favored,
    this.isExpanded,
  });

  // json to Movie object method
  Movie.fromJson(Map json)
      : title = json["title"],
        posterPath = json["poster_path"],
        id = json["id"].toString(),
        overview = json["overview"],
        favored = json["favored"] == 1 ? true : false;

  // convert Movie object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["poster_path"] = posterPath;
    map["overview"] = overview;
    map["favored"] = favored;
    return map;
  }
}
