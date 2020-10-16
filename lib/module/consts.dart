import 'package:flutter/material.dart';

TextStyle headerStyle(){
  return TextStyle(
    fontSize: 24,
  );
}
TextStyle titleStyle(){
  return TextStyle(
    fontSize: 20,
    fontFamily: 'lalezar',
    fontWeight: FontWeight.bold
  );
}
TextStyle header2Style(){
  return TextStyle(
    fontSize: 19,
  );
}
TextStyle gridFieldStyle(){
  return TextStyle(
    fontSize: 15,
    // fontWeight: FontWeight.bold,
    fontFamily: 'lalezar',
  );
}
TextStyle alertButtonStyle(){
  return TextStyle(
    fontSize: 15,
    // fontWeight: FontWeight.bold,
    fontFamily: 'lalezar',
    color: Colors.white
  );
}

Color scaffoldcolor(BuildContext context){
  return Theme.of(context).scaffoldBackgroundColor;
}
Color appbarColor(BuildContext context){
  return Theme.of(context).bottomAppBarColor;
}
Color backgroundColor(BuildContext context){
  return Theme.of(context).backgroundColor;
}
Color accentcolor(BuildContext context){
  return Theme.of(context).accentColor;
}
double screenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}
double screenHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}
