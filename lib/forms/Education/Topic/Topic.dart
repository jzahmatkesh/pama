import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../module/consts.dart';
import '../../../classes/classes.dart';
import 'TopicBloc.dart';
import '../../../module/functions.dart';

import '../../../module/Widgets.dart';

class FmTopic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TopicBloc _bloc = TopicBloc()..loaddata(context);
    return Container(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(
              title: 'فهرست سرفصل های آموزشی', 
              btnRight: MyIconButton(type: ButtonType.add, onPressed: ()=>_bloc.insertRow()), 
              btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_bloc.loaddata(context))
            ),
            GridCaption(obj: ['عنوان سرفصل', 'اساتید'], endbuttons: 2),
            Expanded(
              child: StreamBuilder(
                stream: _bloc.topicStream$,
                builder: (BuildContext context, AsyncSnapshot<TopicModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Topic _top = snap.data.rows[idx];
                          return MyRow(
                            onDoubleTap: ()=>_bloc.editMode(_top.id),
                            color: idx.isOdd ? appbarColor(context) : scaffoldcolor(context),
                            children: [
                              _top.edit 
                                ? Expanded(
                                  child: GridTextField(
                                    hint: 'عنوان سرفصل', 
                                    initialValue: _top.title, 
                                    onChange: (val)=>_top.title=val, 
                                    autofocus: true,
                                  )
                                ) 
                                : '${_top.title}',
                              _top.teachers == null
                                ? Container()
                                : Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: ()=>showFormAsDialog(context: context, form: TeacherManagment(bloc: _bloc, topic: _top)),
                                      child: Tooltip(
                                        message: 'جهت مدیریت اساتید کلیک کنید',
                                        child: TeachersIcons(_top.teachers)
                                      )
                                    )
                                  ),
                              _top.edit 
                                ? MyIconButton(type: ButtonType.save, onPressed: ()=>_bloc.saveData(context, _top))
                                : MyIconButton(type: ButtonType.del, onPressed: ()=>_bloc.delRow(context, _top))
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

class TeachersIcons extends StatelessWidget {
  
  final List<String> teachers;

  TeachersIcons(this.teachers);

  @override
  Widget build(BuildContext context) {
    return teachers.length  > 0
      ? Container(
        height: 50,
        child: Stack(
          children: teachers.asMap().map((idx, e) => MapEntry(idx, Positioned(
            right: idx * 25.0,
            top: 0,
            child: CircleAvatar(
              backgroundImage: e.trim().isEmpty
                ? AssetImage('images/nouser.jpg')
                : NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=${e.trim()}")
            )
          ))).values.toList(),
        ),
      )
      : Container(
        child: Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            backgroundImage: AssetImage('images/nouser.jpg'),
          ),
        ),
      );
  }
}

class TeacherManagment extends StatelessWidget {
  final TopicBloc bloc;
  final Topic topic;

  TeacherManagment({this.bloc, this.topic});

  @override
  Widget build(BuildContext context) {
    bloc.loadTeachers(context, this.topic.id);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        padding: EdgeInsets.all(8),
        width: screenWidth(context)*0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormHeader(title: 'اساتید اختصاص داده شده به سرفصل ${this.topic.title}'),
            Expanded(
              child: StreamBuilder<TopicTeacherModel>(
                stream: bloc.topicTeacherStream$,
                builder: (context, snap) {
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (_, idx)=>MyRow(
                          children: [
                            Switch(value: snap.data.rows[idx].active, onChanged: (val)=>bloc.saveTeacher(context, snap.data.rows[idx]..active=val)),
                            SizedBox(width: 5),
                            CircleAvatar(backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=${snap.data.rows[idx].id}")),
                            SizedBox(width: 5),
                            '${snap.data.rows[idx].name} ${snap.data.rows[idx].family}',
                            SizedBox(width: 5),
                            snap.data.rows[idx].valid
                              ? IconButton(icon: Icon(CupertinoIcons.trash), onPressed: ()=>bloc.delTeacher(context, snap.data.rows[idx]))
                              : Container()
                          ],
                          color: idx.isOdd ?  appbarColor(context): Colors.white,
                        )
                      );
                  return Center(child: CupertinoActivityIndicator());
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}




