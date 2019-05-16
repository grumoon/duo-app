import 'package:duo/model/login_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:duo/constant/constant.dart';
import 'package:duo/model/callback.dart';
import 'package:duo/util/common_util.dart';
import 'package:duo/constant/duo_error.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginManager {
  factory LoginManager() => _getInstance();

  static LoginManager get instance => _getInstance();
  static LoginManager _instance;

  LoginUserModel _loginUserModel;

  LoginManager._internal() {
    _loginUserModel = LoginUserModel(false, 0, '', '', 0, '');
  }

  static LoginManager _getInstance() {
    if (_instance == null) {
      _instance = new LoginManager._internal();
    }
    return _instance;
  }

  Future<Callback> login(String userName, String password) async {
    final response = await http.post(Constant.CGI_LOGIN,
        body: {'user_name': userName, 'password': password},
        encoding: Utf8Codec());
    final responseJson = json.decode(response.body);
    final retCode = responseJson['retcode'];

    print('login responseJson = $responseJson');
    if (retCode == 0) {
      final resultJson = responseJson['result'];
      this._loginUserModel.userId = resultJson['user_id'];
      this._loginUserModel.userName = resultJson['user_name'];
      this._loginUserModel.nick = resultJson['nick'];
      this._loginUserModel.role = resultJson['role'];
      this._loginUserModel.token = resultJson['token'];
      this._loginUserModel.loginFlag = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Constant.SP_KEY_USER_NAME, userName);
      prefs.setString(Constant.SP_KEY_PASSWORD, password);

      return CommonUtil.makeSuccessCallback();
    } else {
      return CommonUtil.makeErrorCallback(
          DuoError.DUO_ERR_NETWORK, 'retCode = $retCode');
    }
  }

  Future<Callback> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString(Constant.SP_KEY_USER_NAME);
    String password = prefs.getString(Constant.SP_KEY_PASSWORD);

    if (userName == null || password == null) {
      return CommonUtil.makeErrorCallback(
          DuoError.DUO_ERR_FAILED, 'no saved user name or password');
    } else {
      return login(userName, password);
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Constant.SP_KEY_USER_NAME);
    prefs.remove(Constant.SP_KEY_PASSWORD);
    this._loginUserModel.loginFlag = false;
    this._loginUserModel.userId = 0;
    this._loginUserModel.userName = '';
    this._loginUserModel.nick = '';
    this._loginUserModel.role = 0;
    this._loginUserModel.token = '';
  }

  LoginUserModel getLoginUserInfo() {
    return _loginUserModel;
  }
}
