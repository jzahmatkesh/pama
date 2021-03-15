
import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/rxdart.dart';

class TopicModel{
  Status status;
  List<Topic> rows;
  String msg;

  TopicModel({@required this.status, this.rows, this.msg});
}

class TopicTeacherModel{
  Status status;
  List<TopicTeacher> rows;
  String msg;

  TopicTeacherModel({@required this.status, this.rows, this.msg});
}

class TopicBloc{
  TopicRepository _repo = new TopicRepository();

  BehaviorSubject<TopicModel> _topicBloc = BehaviorSubject<TopicModel>();
  Stream<TopicModel> get topicStream$ => _topicBloc.stream;

  BehaviorSubject<TopicTeacherModel> _topicTeacherBloc = BehaviorSubject<TopicTeacherModel>();
  Stream<TopicTeacherModel> get topicTeacherStream$ => _topicTeacherBloc.stream;

  loaddata(BuildContext context) async{
    try{
      _topicBloc.add(TopicModel(status: Status.loading));
      _topicBloc.add(TopicModel(status: Status.loaded, rows: await _repo.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _topicBloc.add(TopicModel(status: Status.error, msg: '$e'));
    }
  }

  insertRow(){
    _topicBloc.value.rows.insert(0, Topic(id: 0, title: '', edit: true));
    _topicBloc.add(_topicBloc.value);
  }

  editMode(int id){
    _topicBloc.value.rows.forEach((element) {
      element.edit = element.id==id;
    });
    _topicBloc.add(_topicBloc.value);
  }

  Future<bool> saveData(BuildContext context, Topic top) async{
    if (top.title.isEmpty){
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان سرفصل مشخص نشده است');
      return false;
    }
    else
      try{
        showWaiting(context);
        top.token = readToken(context);
        int _id = await _repo.save(top);
        bool _ext = false;
        _topicBloc.value.rows.forEach((element) {
          if (element.id == top.id){
            element.id = _id;
            element.edit = false;
            _ext = true;
          }
        });
        if (!_ext)
          _topicBloc.value.rows.insert(0, Topic(id: _id, title: top.title, edit: false));
        _topicBloc.add(_topicBloc.value);
        hideWaiting(context);
        return true;
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
        return false;
      }
  }

  delRow(BuildContext context, Topic top) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف سرفصل ${top.title} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        top.token = readToken(context);
        await _repo.delete(top);
        _topicBloc.value.rows.removeWhere((element)=> element.id==top.id);
        _topicBloc.add(_topicBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  loadTeachers(BuildContext context, int topic) async{
    try{
      _topicTeacherBloc.add(TopicTeacherModel(status: Status.loading));
      _topicTeacherBloc.add(TopicTeacherModel(status: Status.loaded, rows: await _repo.loadTeacher(readToken(context), topic)));
    }
    catch(e){
      analyzeError(context, '$e');
      _topicTeacherBloc.add(TopicTeacherModel(status: Status.error, msg: '$e'));
    }
  }
  
  Future<bool> saveTeacher(BuildContext context, TopicTeacher top) async{
    try{
      showWaiting(context);
      top.token = readToken(context);
      if (await _repo.saveTeacher(top)){
        top.valid  =  true;
        bool  _ext = false;
        _topicTeacherBloc.value.rows.forEach((element) {
          if (element.id == top.id){
            element = top;
            _ext = true;
          }
        });
        if (!_ext)
          _topicTeacherBloc.value.rows.insert(0, top);
        _topicTeacherBloc.add(_topicTeacherBloc.value);
        _topicBloc.value.rows.forEach((element) {
          if (element.id==top.topicid){
            if (element.teachers.where((element) => element.trim()==top.id.toString()).length == 0)
              element.teachers.add('${top.id}');
          }
        });
        _topicBloc.add(_topicBloc.value);
        hideWaiting(context);
      }
      return true;
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
      return false;
    }
  }
  
  delTeacher(BuildContext context, TopicTeacher top) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف استاد ${top.name} ${top.family} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        top.token = readToken(context);
        await _repo.delTeacher(top);
        _topicTeacherBloc.value.rows.removeWhere((element)=> element.id==top.id);
        _topicTeacherBloc.add(_topicTeacherBloc.value);
        _topicBloc.value.rows.forEach((element) {
          if (element.id==top.topicid){
            element.teachers.removeWhere((element) => element.trim() ==  '${top.id}');
          }
        });
        _topicBloc.add(_topicBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }
}