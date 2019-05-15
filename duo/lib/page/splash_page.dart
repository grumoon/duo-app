import 'dart:async';

import 'package:duo/constant/duo_error.dart';
import 'package:flutter/material.dart';
import 'package:duo/manager/login_manager.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  bool _delayFinishFlag = false;
  bool _loginFinishFlag = false;
  int _loginCode;

  @override
  void initState() {
    super.initState();
    LoginManager.instance.autoLogin().then((callback) {
      _loginFinishFlag = true;
      _loginCode = callback.errorCode;
      _jump();
    });

    Timer.periodic(Duration(seconds: 2), (Timer t) {
      t.cancel();
      this._delayFinishFlag = true;
      this._jump();
    });
  }

  void _jump() {
    if (_loginFinishFlag && _delayFinishFlag) {
      if (_loginCode == DuoError.DUO_OK) {
        Navigator.of(context).pushReplacementNamed('/MovieListPage');
      } else {
        Navigator.of(context).pushReplacementNamed('/LoginPage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'DUO',
      home: new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(color: Color(0xff007fff)),
          child: new Center(
            child: new Text(
              'D U O',
              style: new TextStyle(
                decorationColor: const Color(0xffffffff),
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.solid,
                wordSpacing: 0.0,
                letterSpacing: 2.0,
                fontStyle: FontStyle.normal,
                fontSize: 40.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xffffffff), //文字颜色
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
