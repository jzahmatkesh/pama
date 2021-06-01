import 'package:flutter/material.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';

class NewParvaneProcess extends StatelessWidget {
  final int parvaneid;

  NewParvaneProcess({@required this.parvaneid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.3,      
      height: screenHeight(context) * 0.5,
      child: Directionality(
        textDirection: TextDirection.rtl,
        // child: Column(
          // children: [
            // FormHeader(title: 'فرآیند مورد نظر را انتخاب نمایید'),
            child: ListView(
              children: [
                // GridTextField(hint: 'جستجو ...'),
                ListTile(
                  title: Text('فرآیند صدور'),
                  onTap: (){},
                ).setPadding().card()
              ],
            )
          // ],
        // ),
      ),
    );
  }
}