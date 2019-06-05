import 'package:flutter/material.dart';
import 'package:movie_search_app/models/movie.dart';
import 'package:movie_search_app/data/movie.dart';
import 'package:rxdart/rxdart.dart';

class Favorites extends StatefulWidget {
  final Map<String, String> env;

  Favorites({Key key, @required this.env}) : super(key: key);

  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Movie> filteredMovies = List();
  List<Movie> movieCache = List();

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    filteredMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    setupList();
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void setupList() async {
    MovieDatabase db = MovieDatabase();
    filteredMovies = await db.getMovies();
    setState(() {
      movieCache = filteredMovies;
    });
  }

  void searchDataList(query) {
    setState(() {
      filteredMovies = query.isEmpty ? movieCache : filteredMovies;
      filteredMovies = filteredMovies
          .where((m) => m.title
              .toLowerCase()
              .trim()
              .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
          .toList();
    });
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => subject.add(string),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: filteredMovies.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return ExpansionTile(
                    initiallyExpanded:
                        filteredMovies[index].isExpanded ?? false,
                    onExpansionChanged: (b) =>
                        filteredMovies[index].isExpanded = b,
                    leading: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          MovieDatabase db = MovieDatabase();
                          db.deleteMovie(filteredMovies[index].id);
                          filteredMovies.remove(filteredMovies[index]);
                        });
                      },
                    ),
                    title: Container(
                      height: 200.0,
                      child: Row(
                        children: <Widget>[
                          filteredMovies[index].posterPath != null
                              ? Hero(
                                  child: Image.network(
                                      "${widget.env['BASE_IMG_URL']}${filteredMovies[index].posterPath}"),
                                  tag: filteredMovies[index].id,
                                )
                              : Container(),
                          Expanded(
                            child: Text(
                              filteredMovies[index].title,
                              textAlign: TextAlign.center,
                              maxLines: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
