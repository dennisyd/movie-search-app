//===================================================================
// File: main.dart
//
// Desc: Main entry point for application.
//
// Copyright © 2019 Edwin Cloud. All rights reserved.
//
// * Attribution to Tensor and his channel on YouTube at      *
// * https://www.youtube.com/channel/UCYqCZOwHbnPwyjawKfE21wg *
//===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show DotEnv;
import 'package:movie_search_app/views/favorites.dart';
import 'package:movie_search_app/views/home.dart';
import 'package:movie_search_app/data/movie.dart';

Map<String, String> _env;

void main() async {
  await DotEnv().load(".env");
  _env = DotEnv().env;
  MovieDatabase()..initDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movie Search",
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Movie Search"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.home),
                  text: "Home Page",
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: "Favorites",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomeView(env: _env),
              Favorites(env: _env),
            ],
          ),
        ),
      ),
    );
  }
}
