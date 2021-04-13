import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../classes/Repository.dart';
import '../../../classes/classes.dart';
import '../../../module/functions.dart';

class CourseModel{
  Status status;
  List<Course> rows;
  String msg;

  CourseModel({this.status, this.rows, this.msg});
}

class CourseBloc{
  CourseRepository _repository = new CourseRepository();

  BehaviorSubject<CourseModel> _courseBloc = BehaviorSubject<CourseModel>.seeded(CourseModel(status: Status.loading));
  Stream<CourseModel> get courseblocStream$ => _courseBloc.stream;

  loadData(BuildContext context) async{
    try{
      _courseBloc.add(CourseModel(status: Status.loading));
      _courseBloc.add(CourseModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _courseBloc.add(CourseModel(status: Status.error, msg: '$e'));
    }
  }
  setActive(BuildContext context, bool val, int id){
    _courseBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.token = readToken(context);
        element.active = val;
        saveCourse(context, element);
      }
    });
  }

  newCourse(BuildContext context){
    _courseBloc.value.rows.insert(0, Course(id: 0, edit: true));
    _courseBloc.add(_courseBloc.value);
  }
  delCourse(BuildContext context, Course course){
    confirmMessage(context, 'حذف دوره', 'آیا مایل به حذف دوره ${course.title} می باشید؟', yesclick: () async{
      try{
        course.token = readToken(context);
        await _repository.delete(course);
        _courseBloc.value.rows.removeWhere((element) => element.id == course.id);
        _courseBloc.add(_courseBloc.value);
      }
      catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
  saveCourse(BuildContext context, Course course) async{
    showWaiting(context);
    try{
      course.token = readToken(context);
      course.id = await _repository.save(course);
      _courseBloc.add(_courseBloc.value);
      hideWaiting(context);
      Navigator.pop(context);
      myAlert(context: context, title: 'موفقیت آمیز', message: 'ذخیره اطلاعات موفقیت آمیز بود', color: Colors.green);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    } 
  }
}
