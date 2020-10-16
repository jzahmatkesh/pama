import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forms/Login/Login.dart';
import 'module/theme-Manager.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeManager()),
    ],
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سامانه پردازش اطلاعات  و مدیریت اعضاء - پاما',
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeManager>().themeData,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Login(),
      },
    );
  }
}

