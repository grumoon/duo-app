import 'package:flutter/material.dart';
import 'page/splash_page.dart';
import 'page/login_page.dart';
import 'page/movie_list_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new SplashPage(), // 闪屏页
        routes: <String, WidgetBuilder>{
          //配置路径
          '/LoginPage': (BuildContext context) => new LoginPage(),
          '/MovieListPage': (BuildContext context) => new MovieListPage(),
        });
  }
}
