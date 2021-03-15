import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/rxdart.dart';

class TeacherModel{
  Status status;
  List<Teacher> rows;
  String msg;

  TeacherModel({@required this.status, this.rows, this.msg});
}

class TeacherBloc{
  TeacherRepository _repo = new TeacherRepository();

  BehaviorSubject<TeacherModel> _teacherBloc = BehaviorSubject<TeacherModel>();
  Stream<TeacherModel> get teacherStream$ => _teacherBloc.stream;
  List<Teacher> get teachers$ => _teacherBloc.stream.value.rows ?? [];

  loaddata(BuildContext context) async{
    try{
      _teacherBloc.add(TeacherModel(status: Status.loading));
      _teacherBloc.add(TeacherModel(status: Status.loaded, rows: await _repo.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _teacherBloc.add(TeacherModel(status: Status.error, msg: '$e'));
    }
  }

  setActive(BuildContext context, int id) async{
    List<Teacher> _rows = _teacherBloc.value.rows;
    try{
      _rows.forEach((element) {if (element.id==id) element.teacheract = !element.teacheract;});
      showWaiting(context);
      await _repo.save(_rows.where((element) => element.id==id).first..token="${readToken(context)}");
      _teacherBloc.add(TeacherModel(status: Status.loaded, rows: _rows));
    }
    catch(e){
      analyzeError(context, '$e');
    }
    finally{
      hideWaiting(context);
    }

  }
}