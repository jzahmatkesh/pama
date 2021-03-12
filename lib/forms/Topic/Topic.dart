import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/module/consts.dart';
import '../../classes/classes.dart';
import 'TopicBloc.dart';
import '../../module/functions.dart';

import '../../module/Widgets.dart';

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
              btnRight: MyIconButton(type: ButtonType.add, onPressed: (){}), 
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
                            onDoubleTap: (){},
                            color: idx.isOdd ? appbarColor(context) : scaffoldcolor(context),
                            children: [
                              _top.edit ? Expanded(child: GridTextField(hint: 'عنوان سرفصل', initialValue: _top.title, onChange: (val)=>_top.title=val, autofocus: true,)) : '${_top.title}',
                              Expanded(child: TeachersIcons(_top.teachers)),
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
  
  final String teachers;

  TeachersIcons(this.teachers);

  @override
  Widget build(BuildContext context) {
    int i =  0;
    return teachers.split(',').length > 1
      ? Container(
        height: 50,
        child: Stack(
          children: teachers.split(',').asMap().map((idx, e) => MapEntry(idx, Positioned(
            right: idx*22.0,
            top: 0,
            child: CircleAvatar(backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=${teachers.split(',')[idx].trim()}"))
          ))).values.toList(),
        ),
      )
      : Container();
  }
}