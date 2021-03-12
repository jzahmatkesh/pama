import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../module/Widgets.dart';
import '../../module/functions.dart';
import '../../module/responsiveLayout.dart';
import '../../module/theme-Manager.dart';
import '../Dashboard/Dashboard.dart';
import 'LoginBloc.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginBloc _loginBloc = LoginBloc();

    Future.delayed(Duration(milliseconds: 3)).then((e){
      _loginBloc.verify();
    });

    _loginBloc.stream$.listen((data){
      if (data.status == LoginStatus.error)
        myAlert(context: context, title: 'خطا', message: data.msg);
      else if (data.status == LoginStatus.loaded){
          context.read<ThemeManager>().setToken(data.user.token, data.user.ejriat);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(user: data.user,)),
          );
      }
    });
    Map<String, String> _logindata = {'username': '', 'pass': ''};


    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl, 
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: loadImage(context, 'images/login-background.jpg'),
                fit: BoxFit.cover
              )
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: (ResponsiveLayout.isSmallScreen(context)) ? double.infinity : 450.0,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Lottie.asset('images/fingerprint.json', height: 200, fit: BoxFit.cover),
                      // child: Icon(Icons.fingerprint, size: 150, color: Colors.lightGreen.withOpacity(0.3))
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey[500]),
                        color: Colors.white12
                      ),
                      child: StreamBuilder(
                        stream: serverBloc.serverIPStream$,
                        initialData: '185.4.31.101',
                        builder: (BuildContext context, AsyncSnapshot<String> snap){
                          return DropdownButton(
                            style: TextStyle(color: Colors.grey, fontFamily: 'nazanin'),
                            value: snap.data ?? '185.4.31.101',
                            underline: Container(),
                            isExpanded: true,
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(value: '127.0.0.1', child: Container(alignment: Alignment.centerRight, child: Text('سیستم جاری سرور می باشد'))),
                              DropdownMenuItem(value: '185.4.31.101', child: Container(alignment: Alignment.centerRight, child: Text('سرور اتاق اصناف مشهد'))),
                            ], 
                            onChanged: (val) => serverBloc.setServerIP(val),
                          );
                        },
                      ),
                    ),
                    MyTextField(hint: 'شماره همراه', onchange: (val){_logindata['username']=val;}, darkmodeForce: true,),
                    MyTextField(hint: 'کلمه عبور', pass: true, onchange: (val){_logindata['pass']=val;}, darkmodeForce: true,),
                    SizedBox(height: 15.0,),
                    Row(
                      children: <Widget>[
                        StreamBuilder(
                          stream: _loginBloc.stream$,
                          initialData: LoginModel(status: LoginStatus.initial),
                          builder: (BuildContext context, AsyncSnapshot<LoginModel> snap){
                            return Checkbox(
                              value: snap.data.remind, 
                              onChanged: (val){
                                _loginBloc.setRemindMe(val);
                              },
                              hoverColor: Colors.black12,
                              checkColor: Colors.grey
                            );
                          },
                        ),
                        Text('مرا بخاطر بسپار', style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      children: <Widget>[
                        StreamBuilder<LoginModel>(
                          stream: _loginBloc.stream$,
                          initialData: LoginModel(status: LoginStatus.initial),
                          builder: (BuildContext context, AsyncSnapshot<LoginModel> snap){
                            if (snap.data.status == LoginStatus.loading)
                              return Center(child: CircularProgressIndicator(),);
                            else 
                              return MyOutlineButton(
                                title: 'ورود به سیستم',
                                color: Colors.lightGreen,
                                icon: Icons.fingerprint,
                                onPressed: () {
                                  if (_logindata['username'].isEmpty || _logindata['pass'].isEmpty)
                                    myAlert(
                                      context: context,
                                      title: 'خطا',
                                      message: 'شناسه کاربری/کلمه عبور مشخص نشده است',
                                      color: Colors.deepOrange
                                    );
                                  else
                                    _loginBloc.authenticate(_logindata['username'], _logindata['pass']);
                                },
                              );
                          }
                        ),
                        SizedBox(width: 5.0,),
                        TextButton(
                          onPressed: () {myAlert(context: context, title: 'هشدار', message: 'با مدیر سیستم تماس حاصل نمایید', color: Colors.deepOrange);},
                          child: Text('رمز عبورم را فراموش کرده ام!', style: TextStyle(fontFamily: 'yekan',color: Colors.grey))
                        )
                      ]
                    )
                  ]
                )
              )
            )
          ),
        )
      )
    );
  }
}