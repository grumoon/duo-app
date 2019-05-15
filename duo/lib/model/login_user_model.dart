class LoginUserModel {
  bool loginFlag;
  int userId;
  String userName;
  String nick;
  int role;
  String token;

  LoginUserModel(this.loginFlag, this.userId, this.userName, this.nick,
      this.role, this.token);
}
