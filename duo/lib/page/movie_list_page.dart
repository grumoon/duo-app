import 'dart:async';
import 'dart:convert';

import 'package:duo/constant/constant.dart';
import 'package:duo/manager/login_manager.dart';
import 'package:duo/model/movie_model.dart';
import 'package:duo/page/movie_play_page.dart';
import 'package:duo/page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<MovieModel>> fetchMovieList() async {
  final response = await http.post(Constant.CGI_GET_MOVIE_LIST,
      body: {
        "user_id": LoginManager.instance.getLoginUserInfo().userId.toString(),
        "token": LoginManager.instance.getLoginUserInfo().token
      },
      encoding: Utf8Codec());
  final responseJson = json.decode(response.body);
  final retCode = responseJson['retcode'];

  List<MovieModel> movieList = new List<MovieModel>();

  if (retCode == 0) {
    List jsonList = responseJson['result'];
    jsonList.forEach((item) {
      movieList.add(MovieModel.fromJson(item));
    });
  }

  return movieList;
}

List<Widget> getWidgetList(BuildContext context, List<MovieModel> movieList) {
  List<Widget> widgetList = new List();
  movieList.forEach((item) {
    widgetList.add(new ListTile(
        title: new Text(item.name),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new MoviePlayPage(movieModel: item)),
          );
        }));
  });
  return widgetList;
}

class MovieListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MovieListPageState();
  }
}

class MovieListPageState extends State<MovieListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Movie List',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('影片列表'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                tooltip: "用户",
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ProfilePage()),
                  );
                },
              ),
            ],
          ),
          body: new Center(
            child: new FutureBuilder<List<MovieModel>>(
              future: fetchMovieList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new ListView(
                      children: ListTile.divideTiles(
                              context: context,
                              tiles: getWidgetList(context, snapshot.data))
                          .toList());
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return new CircularProgressIndicator();
              },
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
