import 'package:flutter/material.dart';
import 'package:movie_search_app/models/movie.dart';
import 'package:movie_search_app/data/movie.dart';

class MovieView extends StatefulWidget {
  final Movie movie;
  final Map<String, String> env;

  MovieView({Key key, @required this.movie, @required this.env})
      : super(key: key);

  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  @override
  void initState() {
    super.initState();
    MovieDatabase db = MovieDatabase();
    db
        .getMovie(widget.movie.id)
        .then((movie) => setState(() => widget.movie.favored = movie.favored));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: widget.movie.isExpanded ?? false,
      onExpansionChanged: (b) => widget.movie.isExpanded = b,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
              ),
              text: widget.movie.overview,
            ),
          ),
        )
      ],
      leading: IconButton(
        icon: widget.movie.favored ? Icon(Icons.star) : Icon(Icons.star_border),
        color: Colors.white,
        onPressed: () {
          MovieDatabase db = MovieDatabase();
          setState(() {
            widget.movie.favored = !widget.movie.favored;
          });
          widget.movie.favored == true
              ? db.addMovie(widget.movie)
              : db.deleteMovie(widget.movie.id);
        },
      ),
      title: Container(
        height: 200.0,
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            widget.movie.posterPath != null
                ? Hero(
                    child: Image.network(
                        "${widget.env['BASE_IMG_URL']}${widget.movie.posterPath}"),
                    tag: widget.movie.id,
                  )
                : Container(),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        widget.movie.title,
                        maxLines: 10,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
