import 'dart:math';

import 'package:flutter/material.dart';

import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';

class FmAttach extends StatelessWidget{
  const FmAttach({Key key, @required this.title, @required this.url, @required this.header}) : super(key: key);

  final String title;
  final String url;
  final Map<String, String> header;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenHeight(context) * 0.75,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(
              title: this.title, 
              btnRight: MyIconButton(
                type: ButtonType.add, 
                onPressed: ()=>prcUploadImg(
                  context: context, 
                  id: 0, 
                  tag: "$url", 
                  cmpid: int.tryParse(header['cmpid']),
                  id1: int.tryParse(header['id1'] ?? '0'),
                  id2: int.tryParse(header['id2'] ?? '0'),
                  id3: int.tryParse(header['id3'] ?? '0'),
                  id4: int.tryParse(header['id4'] ?? '0'),
                  id5: int.tryParse(header['id5'] ?? '0'),
                  ondone: (){
                    int _flg = Random().nextInt(48812); 
                    print('$_flg');
                  }
                )
              )
            ),
          ]
        )
      )
    );
  }
}