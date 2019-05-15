import 'package:flutter/material.dart';

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
    return new Center(
      child: new Text('Movie List Page'),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}