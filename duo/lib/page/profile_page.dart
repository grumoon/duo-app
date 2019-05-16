import 'package:duo/manager/login_manager.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Profile',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('个人信息'),
            ),
            body: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: new Row(
                      children: <Widget>[
                        Container(
                            width: 80,
                            child: Text('用户名', style: TextStyle(fontSize: 20))),
                        Text(
                          '${LoginManager.instance.getLoginUserInfo().userName}',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: new Row(
                      children: <Widget>[
                        Container(
                            width: 80,
                            child: Text('昵   称', style: TextStyle(fontSize: 20))),
                        Text(
                          '${LoginManager.instance.getLoginUserInfo().nick}',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 200, 15, 0),
                    child: Center(
                      child: SizedBox(
                          height: 50.0,
                          width: 270.0,
                          child: RaisedButton(
                              child: Text(
                                '退出登录',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              color: Colors.red,
                              onPressed: () {
                                LoginManager.instance.logout();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/LoginPage', ModalRoute.withName('/'));
                              })),
                    ))
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
