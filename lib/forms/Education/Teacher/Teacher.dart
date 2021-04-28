import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../classes/classes.dart';
import '../../../module/Widgets.dart';
import '../../../module/consts.dart';
import '../../../module/functions.dart';
import '../../People/People.dart';
import '../Teacher/TeacherBloc.dart';

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
                            onDoubleTap: ()=>showFormAsDialog(context: context, form: TeacherEdit(bloc: _bloc, teacher: _peop)),
                            color: idx.isOdd ? appbarColor(context) : scaffoldcolor(context),
                            children: [
                              Switch(value: _peop.teacheract, onChanged: (val)=>_bloc.setActive(context, _peop.id)),
                              '${_peop.name} ${_peop.family}',
                              '${_peop.nationalid}',
                              '${_peop.educationName()}',
                              '${_peop.mobile}',
                              MyIconButton(icon: Icon(Icons.calendar_today_sharp, color: Colors.grey.shade600,),type: ButtonType.other, hint: 'سرفصل های آموزشی', onPressed: ()=>showFormAsDialog(context: context, form: Topics(bloc: _bloc, teacher: _peop))),
                              MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delTeacher(context, _peop))
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
    TextEditingController _bdate = TextEditingController(text: this.teacher.teacherbegindate.trim());
    TextEditingController _edate = TextEditingController(text: this.teacher.teacherenddate.trim());
    FocusNode _fbdate = FocusNode();
    FocusNode _fedate = FocusNode();
    FocusNode _fshaba = FocusNode();
    FocusNode _fnote = FocusNode();
    final _formkey = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        color: Colors.white,
        width: screenWidth(context) * 0.5,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'ویرایش اطلاعات', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){
                if (_formkey.currentState.validate()){
                  teacher.teacherbegindate = _bdate.text;
                  teacher.teacherenddate = _edate.text;
                  bloc.saveData(context, teacher);
                }
              })),
              MyRow(children: [
                'نام و نام خانوادگی',
                '${teacher.name} ${teacher.family}',
                MyIconButton(type: ButtonType.info, hint: 'اطلاعات فردی', onPressed: () => showFormAsDialog(context: context, form: FmPeople(justcheck: false, nationalid: teacher.nationalid,))),
              ]),
              MyRow(children: [
                'تحصیلات',
                '${teacher.educationName()}',
              ]),
              MyRow(children: [
                'شماره  همراه',
                '${teacher.mobile}',
              ]),
              MyRow(children: [
                Expanded(child: GridTextField(hint: 'تاریخ آغاز همکاری', controller: _bdate, focus: _fbdate, nextfocus: _fedate, datepicker: true, notempty: true, autofocus: true)),
                Expanded(child: GridTextField(hint: 'تاریخ پایان همکاری', controller: _edate, focus: _fedate, nextfocus: _fshaba, datepicker: true, notempty: true)),
              ]),
              MyRow(children: [
                Expanded(child: GridTextField(hint: 'شماره حساب شبا', initialValue: '${this.teacher.shaba.trim()}', focus: _fshaba, nextfocus: _fnote, notempty: true, onChange: (val)=>teacher.shaba=val)),
                Expanded(flex: 2, child: GridTextField(hint: 'توضیحات', initialValue: '${this.teacher.teachernote.trim()}', focus: _fnote, nextfocus: _fbdate, onChange: (val)=>teacher.teachernote=val)),
              ]),
            ],
          ),
        ),
      )
    );
  }
}


class Topics extends StatelessWidget {
  final TeacherBloc bloc;
  final Teacher teacher;

  Topics({@required this.bloc, @required this.teacher});

  @override
  Widget build(BuildContext context) {
    bloc.loadTopics(context, teacher.id);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'سرفصل های آموزشی'),
            GridCaption(
              obj: [
                Text('فعال', style: gridFieldStyle()), 
                'عنوان سرفصل'
              ], 
              endbuttons: 1
            ),
            Expanded(
              child:StreamBuilder<TeacherTopicModel>(
                stream: bloc.teacherTopicStream$,
                builder: (_, snap){
                  if (snap.hasData)
                    if (snap.data.status ==  Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status ==  Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (_, idx)=>MyRow(children: [
                          Switch(value: snap.data.rows[idx].active, onChanged: (val)=>bloc.addTopic(context, snap.data.rows[idx])),
                          '${snap.data.rows[idx].title}',
                           snap.data.rows[idx].valid
                            ? MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delopic(context, snap.data.rows[idx]))
                            : Container()
                        ]),
                      );
                  return Center(child: CupertinoActivityIndicator());
                },
              )
            )
          ],
        ),
      )
    );
  }
}

