import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/forms/People/People.dart';
import 'package:pama/forms/Teacher/TeacherBloc.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';

class FmTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TeacherBloc _bloc = TeacherBloc()..loaddata(context);
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(
              title: 'فهرست اساتید', 
              btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>showFormAsDialog(context: context, form: FmPeople(nationalid: "", justcheck: true,), done: (dynamic data){
                if (data is People){
                  if (_bloc.teachers$.where((element) => element.id == data.id).length > 0)
                    myAlert(context: context, title: "توجه", message: "${data.name} ${data.family} قبلا اختصاص داده شده است");
                  else
                    showFormAsDialog(
                      context: context, 
                      form: TeacherEdit(
                        bloc: _bloc, 
                        teacher:new Teacher(
                          id: data.id,
                          name: data.name,
                          family: data.family,
                          nationalid: data.nationalid,
                          mobile: data.mobile,
                          education: data.education,
                        ),
                      )
                    );
                }
              })), 
              btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_bloc.loaddata(context))
            ),
            GridCaption(obj: [Text('فعال', style: gridFieldStyle()), 'نام و نام خانوادگی', 'کد ملی', 'تحصیلات', 'شماره همراه'], endbuttons: 2),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.teacherStream$,
                builder: (BuildContext context, AsyncSnapshot<TeacherModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (cnt, idx){
                          Teacher _peop = snap.data.rows[idx];
                          return MyRow(
                            onDoubleTap: (){},
                            color: idx.isOdd ? appbarColor(context) : scaffoldcolor(context),
                            children: [
                              Switch(value: _peop.teacheract, onChanged: (val)=>_bloc.setActive(context, _peop.id)),
                              '${_peop.name} ${_peop.family}',
                              '${_peop.nationalid}',
                              '${_peop.educationName()}',
                              '${_peop.mobile}',
                              MyIconButton(icon: Icon(Icons.calendar_today_sharp, color: Colors.grey.shade600,),type: ButtonType.other, hint: 'سرفصل های آموزشی', onPressed: (){}),
                              MyIconButton(type: ButtonType.del, onPressed: (){})
                            ]
                          );
                        }
                      );
                    return Center(child: CupertinoActivityIndicator());
                }
              )
            )
          ]
        )
      )
    );
  }
}

class TeacherEdit extends StatelessWidget {
  final TeacherBloc bloc;
  final Teacher teacher;

  TeacherEdit({this.bloc, this.teacher});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'ویرایش اطلاعات', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){}))
          ],
        ),
      )
    );
  }
}