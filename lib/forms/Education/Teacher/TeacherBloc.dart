import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../classes/Repository.dart';
import '../../../classes/classes.dart';
import '../../../module/functions.dart';

class TeacherModel{
  Status status;
  List<Teacher> rows;
  String msg;

  TeacherModel({@required this.status, this.rows, this.msg});
}
class TeacherTopicModel{
  Status status;
  List<TeacherTopic> rows;
  String msg;

  TeacherTopicModel({@required this.status, this.rows, this.msg});
}

class TeacherBloc{
  TeacherRepository _repo = new TeacherRepository();

  BehaviorSubject<TeacherModel> _teacherBloc = BehaviorSubject<TeacherModel>();
  Stream<TeacherModel> get teacherStream$ => _teacherBloc.stream;
  List<Teacher> get teachers$ => _teacherBloc.stream.value.rows ?? [];

  BehaviorSubject<TeacherTopicModel> _teacherTopicBloc = BehaviorSubject<TeacherTopicModel>();
  Stream<TeacherTopicModel> get teacherTopicStream$ => _teacherTopicBloc.stream;

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

  saveData(BuildContext context, Teacher data)async{
    try{
      showWaiting(context);
      data.token = readToken(context);
      await _repo.save(data);
      if (teachers$.where((element) => element.id==data.id).length>0){
        teachers$.where((element) => element.id==data.id).first.teacherbegindate = data.teacherbegindate;
        teachers$.where((element) => element.id==data.id).first.teacherbegindate = data.teacherbegindate;
      }
      else
        teachers$.insert(0, data);
      _teacherBloc.add(_teacherBloc.value);
      Navigator.of(context).pop();
    }
    catch(e){
      analyzeError(context, '$e');
    }
    finally{
      hideWaiting(context);
    }
  }

  delTeacher(BuildContext context, Teacher data)async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${data.name} ${data.family} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        data.token = readToken(context);
        await _repo.delete(data);
        teachers$.removeWhere((element) => element.id==data.id);
        _teacherBloc.add(_teacherBloc.value);
        myAlert(context: context, title: 'موفقیت آمیز', message: 'حذف استاد با موفقیت انجام گردید', color: Colors.green);
      }
      catch(e){
        analyzeError(context, '$e');
      }
      finally{
        hideWaiting(context);
        Navigator.pop(context);
      }
    });
  }

  loadTopics(BuildContext context, int id) async{
    try{
      _teacherTopicBloc.add(TeacherTopicModel(status: Status.loading));
      _teacherTopicBloc.add(TeacherTopicModel(status: Status.loaded, rows: await _repo.loadTopic(readToken(context), id)));
    }
    catch(e){
      analyzeError(context, '$e');
      _teacherTopicBloc.add(TeacherTopicModel(status: Status.error, msg: '$e'));
    }
  }

  addTopic(BuildContext context, TeacherTopic top) async{
    TopicRepository _topicrepo = new TopicRepository();
    try{
      await _topicrepo.saveTeacher(TopicTeacher(topicid: top.id, id: top.peopid, active: !top.active, token: readToken(context)));
      _teacherTopicBloc.value.rows.forEach((element) {
        if (element.id==top.id){
          element.valid = true;
          element.active = !top.active;
        }
      });
      _teacherTopicBloc.add(_teacherTopicBloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }
  delopic(BuildContext context, TeacherTopic top) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${top.title} می باشید؟', yesclick: () async{
      TopicRepository _topicrepo = new TopicRepository();
      try{
        await _topicrepo.delTeacher(TopicTeacher(topicid: top.id, id: top.peopid, token: readToken(context)));
        _teacherTopicBloc.value.rows.forEach((element) {
          if (element.id==top.id){
            element.valid = false;
            element.active = false;
          }
        });
        _teacherTopicBloc.add(_teacherTopicBloc.value);
      }
      catch(e){
        analyzeError(context, '$e');
      }
      finally{
        Navigator.pop(context);
      }
    });
  }
}