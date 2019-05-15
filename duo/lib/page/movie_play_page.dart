//import 'dart:async';
//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//
//Future<List<Movie>> fetchMovieList() async {
//  final response = await http.post(
//      'http://www.zhangxuzhou.cn:88/movie/get_movie_list',
//      body: {"user_id": "2", "token": "5ed53a30-7349-11e9-a875-51fcd58c75e0"},
//      encoding: Utf8Codec());
//  final responseJson = json.decode(response.body);
//  final retCode = responseJson['retcode'];
//
//  List<Movie> movieList = new List<Movie>();
//
//  if (retCode == 0) {
//    List jsonList = responseJson['result'];
//    jsonList.forEach((item) {
//      movieList.add(Movie.fromJson(item));
//    });
//  }
//
//  return movieList;
//}
//
//List<Widget> getWidgetList(List<Movie> movieList) {
//  List<Widget> widgetList = new List();
//  movieList.forEach((item) {
//    widgetList.add(new ListTile(
//      title: new Text(item.name),
//    ));
//  });
//  return widgetList;
//}
//
//class Movie {
//  final int movieId;
//  final String name;
//  final String audio;
//  final String subtitles;
//
//  Movie({this.movieId, this.name, this.audio, this.subtitles});
//
//  factory Movie.fromJson(Map<String, dynamic> json) {
//    return new Movie(
//      movieId: json['movie_id'],
//      name: json['name'],
//      audio: json['audio'],
//      subtitles: json['subtitles'],
//    );
//  }
//}
//
//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Movie List',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Movie List'),
//        ),
//        body: new Center(
//          child: new FutureBuilder<List<Movie>>(
//            future: fetchMovieList(),
//            builder: (context, snapshot) {
//              if (snapshot.hasData) {
//                return new ListView(children: getWidgetList(snapshot.data));
//              } else if (snapshot.hasError) {
//                return new Text("${snapshot.error}");
//              }
//
//              // By default, show a loading spinner
//              return new CircularProgressIndicator();
//            },
//          ),
//        ),
//      ),
//    );
//  }
//}
