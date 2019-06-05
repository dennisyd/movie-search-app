import 'package:flutter/material.dart';
import 'package:movie_search_app/models/movie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_search_app/views/movie.dart';

class HomeView extends StatefulWidget {
  final Map<String, String> env;

  HomeView({Key key, @required this.env}) : super(key: key);

  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // class variables
  List<Movie> movies = List();
  bool hasLoaded = true;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subject.stream
        .debounceTime(Duration(milliseconds: 400))
        .listen(searchMovies);
  }

  void searchMovies(query) {
    setState(() {
      movies.clear();
      hasLoaded = query.isEmpty ? true : false;
    });
    http
        .get(
            "${widget.env['MOVIEDB_API_URL']}/search/movie?api_key=${widget.env['MOVIEDB_API_KEY']}&query=$query")
        .then((res) => res.body)
        .then(json.decode)
        // .then((map) => map["results"])
        .then((jsonMap) => (jsonMap["results"] as List).forEach((item) {
              setState(() => movies.add(Movie.fromJson(item)));
            }))
        // .catchError((e) => setState(() => hasLoaded = true))
        .then((e) => setState(() => hasLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => subject.add(string),
          ),
          hasLoaded ? Container() : CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: movies.length,
              itemBuilder: (BuildContext ctx, int index) => MovieView(
                    env: widget.env,
                    movie: movies[index],
                  ),
            ),
          )
        ],
      ),
    );
  }
}
