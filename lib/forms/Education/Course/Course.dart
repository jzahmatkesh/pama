import 'package:flutter/material.dart';
import 'package:pama/forms/Education/Course/CourseBloc.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';

class FmCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CourseBloc _cousr
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(
              title: 'دوره های آموزشی', 
              btnRight: MyIconButton(type: ButtonType.add, onPressed: (){}), 
              btnLeft: MyIconButton(type: ButtonType.reload, onPressed: (){})
            ),
            GridCaption(
              obj: [
                Text('فعال', style: gridFieldStyle(),), 
                'عنوان دوره',
                'نوع دوره',
                'نحوه حضور',
                'هزینه'
              ], 
              endbuttons: 2
            ),
          ]
        )
      )
    );
  }
}