import 'package:duo/constant/duo_error.dart';
import 'package:duo/manager/login_manager.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  String _userName, _password;
  bool _isObscure = true;
  Color _eyeColor = Colors.white54;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: new Container(
            decoration: BoxDecoration(color: Colors.blue),
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  children: <Widget>[
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    buildTitle(),
                    buildTitleLine(),
                    SizedBox(height: 100.0),
                    buildUserNameTextField(),
                    SizedBox(height: 30.0),
                    buildPasswordTextField(context),
                    SizedBox(height: 60.0),
                    buildLoginButton(context),
                    SizedBox(height: 30.0),
                  ],
                ))));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
            child: Text(
              '登录',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            color: Colors.white,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                LoginManager.instance
                    .login(this._userName.trim(), this._password.trim())
                    .then((callback) {
                  if (callback.errorCode == DuoError.DUO_OK) {
                    Navigator.of(context)
                        .pushReplacementNamed('/MovieListPage');
                  } else {
                    final snackBar = new SnackBar(
                      content: new Text('登录失败，请检查用户名或密码'),
                      backgroundColor: Colors.red,
                    );
                    _scaffoldkey.currentState.showSnackBar(snackBar);
                  }
                });
              }
            }),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      style: new TextStyle(color: Colors.white, fontSize: 24),
      cursorColor: Colors.white,
      decoration: InputDecoration(
          labelText: '密码',
          labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1)),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure ? Colors.white54 : Colors.white;
                });
              })),
    );
  }

  TextFormField buildUserNameTextField() {
    return TextFormField(
      style: new TextStyle(color: Colors.white, fontSize: 24),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: '用户名',
        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1)),
      ),
      validator: (String value) {
        var userNameReg = RegExp(r'[a-zA-Z0-9]');
        if (!userNameReg.hasMatch(value)) {
          return '请输入正确的用户名';
        }
      },
      onSaved: (String value) => _userName = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.white,
          width: 90.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '登录',
        style: TextStyle(fontSize: 42.0, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
