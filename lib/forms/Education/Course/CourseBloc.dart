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
class ClassModel{
  Status status;
  List<Class> rows;
  String msg;

  ClassModel({this.status, this.rows, this.msg});
}

class CourseBloc{
  CourseRepository _repository = new CourseRepository();

  BehaviorSubject<CourseModel> _courseBloc = BehaviorSubject<CourseModel>.seeded(CourseModel(status: Status.loading));
  Stream<CourseModel> get courseblocStream$ => _courseBloc.stream;

  BehaviorSubject<ClassModel> _classBloc = BehaviorSubject<ClassModel>.seeded(ClassModel(status: Status.loading));
  Stream<ClassModel> get classblocStream$ => _classBloc.stream;

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

  refresh()=>_courseBloc.add(_courseBloc.value);
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
  saveCourse(BuildContext context, Course course, {bool pop = true}) async{
    showWaiting(context);
    try{
      course.token = readToken(context);
      course.id = await _repository.save(course);
      if (_courseBloc.value.rows.where((element) => element.id==course.id).length == 0)
        _courseBloc.value.rows.insert(0, course);
      _courseBloc.add(_courseBloc.value);
      hideWaiting(context);
      if (pop){
        Navigator.pop(context);
        myAlert(context: context, title: 'موفقیت آمیز', message: 'ذخیره اطلاعات موفقیت آمیز بود', color: Colors.green);
      }
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    } 
  }  


  showClass(BuildContext context, int crsid) async{
    try{
      _courseBloc.value.rows.forEach((element)=>element.showclass = element.id==crsid && !element.showclass);
      if (_courseBloc.value.rows.where((element) => element.id==crsid).first.showclass){
        _classBloc.add(ClassModel(status: Status.loading));
        _classBloc.add(ClassModel(status: Status.loaded, rows: await _repository.loadClass(readToken(context), crsid)));
      }
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _classBloc.add(ClassModel(status: Status.error, msg: '$e'));
    }
    finally{
      _courseBloc.add(_courseBloc.value);
    }
  }
  delClass(BuildContext context, Class obj){
    confirmMessage(context, 'حذف کلاس', 'آیا مایل به حذف کلاس ${obj.title} می باشید؟', yesclick: () async{
      try{
        obj.token = readToken(context);
        await _repository.deleteClass(obj);
        _classBloc.value.rows.removeWhere((element) => element.id == obj.id);
        _classBloc.add(_classBloc.value);
      }
      catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
  saveClass(BuildContext context, Class obj) async{
    showWaiting(context);
    try{
      obj.token = readToken(context);
      obj.id = await _repository.saveClass(obj);
      obj.edit = false;
      if (_classBloc.value.rows.where((element) => element.id==obj.id).length == 0)
        _classBloc.value.rows.insert(0, obj);
      _classBloc.add(_classBloc.value);
      hideWaiting(context);
      myAlert(context: context, title: 'موفقیت آمیز', message: 'ذخیره اطلاعات موفقیت آمیز بود', color: Colors.green);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    } 
  }  
  newClass(int courseid){
    _classBloc.value.rows.insert(0, Class(courseid: courseid, edit: true));
    _classBloc.add(_classBloc.value);
  }
  editClass(Class cls){
    cls.edit = true;
    _classBloc.add(_classBloc.value);
  }
}
