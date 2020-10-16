import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/classes.dart';
import '../../module/functions.dart';

enum LoginStatus{initial, loading, loaded, error}

class LoginModel{
  LoginStatus status;
  User user;
  bool remind;
  String msg;

  LoginModel({this.status, this.user, this.remind = false, this.msg});
}

class LoginBloc{
  BehaviorSubject<LoginModel> _loginbloc = BehaviorSubject<LoginModel>.seeded(LoginModel(status: LoginStatus.initial));

  LoginBloc(){
    SharedPreferences.getInstance().then((prefs) {
      String token = prefs.getString('token') ?? '';

      if (token.isNotEmpty){
        verify(token);
      }
    });
  }

  Stream<LoginModel> get stream$ => _loginbloc.stream;

  setRemindMe(bool val){
    _loginbloc.value.remind = val;
    _loginbloc.value.status = LoginStatus.initial;
    _loginbloc.add(_loginbloc.value);
  }

  authenticate(String username, String pass) async{
    _loginbloc.add(LoginModel(status: LoginStatus.loading, remind: _loginbloc.value.remind));
    try{
      var res = await postToServer(api: 'User/login', body: jsonEncode({"username": username, "password": generateMd5(pass)}));
      if (res["msg"] == "Success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', res['body']['token']);
        _loginbloc.add(
          LoginModel(
            status: LoginStatus.loaded, 
            remind: _loginbloc.value.remind,
            user: User(
              cmpid: int.parse(res['body']['cmpid']), 
              cmpname: res['body']['cmptitle'], 
              id: int.parse(res['body']['id']), 
              sex: int.parse(res['body']['sex']), 
              name: res['body']['name'], 
              family: res['body']['family'], 
              mobile: res['body']['mobile'], 
              // pic: res['body']['pic'], 
              lastlogin: res['body']['lastlogin'], 
              ip: res['body']['ip'],
              admin: res['body']['admin']==1,
              token: res['body']['token']
            )
          )
        );
      } else {
        _loginbloc.add(LoginModel(status: LoginStatus.error, remind: _loginbloc.value.remind, msg: res['msg']));
      } 
    }
    catch(e){
      _loginbloc.add(LoginModel(status: LoginStatus.error, msg: compileErrorMessage(e.toString())));
    }
  }

  verify(String token) async{
    _loginbloc.add(LoginModel(status: LoginStatus.loading, remind: _loginbloc.value.remind));
    try{
      var res = await postToServer(api: 'User/verify', body: jsonEncode({"token": token}));
      if (res["msg"] == "Success") {
        _loginbloc.add(
          LoginModel(
            status: LoginStatus.loaded, 
            remind: _loginbloc.value.remind,
            user: User(
              cmpid: int.parse(res['body']['cmpid']), 
              cmpname: res['body']['cmptitle'], 
              id: int.parse(res['body']['id']), 
              sex: int.parse(res['body']['sex']), 
              name: res['body']['name'], 
              family: res['body']['family'], 
              mobile: res['body']['mobile'], 
              // pic: res['body']['pic'], 
              lastlogin: res['body']['lastlogin'], 
              ip: res['body']['ip'],
              admin: res['body']['admin'] == 1,
              token: res['body']['token']
            )
          )
        );
      } else {
        _loginbloc.add(LoginModel(status: LoginStatus.error, remind: _loginbloc.value.remind, msg: res['msg']));
      } 
    }
    catch(e){
      _loginbloc.add(LoginModel(status: LoginStatus.error, msg: compileErrorMessage(e.toString())));
    }
  }
}