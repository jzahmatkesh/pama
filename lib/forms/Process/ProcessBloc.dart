import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/rxdart.dart';

class ProcessModel{
  Status status;
  List<Process> rows;
  String msg;

  ProcessModel({@required this.status, this.rows, this.msg});
}

class ProcessBloc{
  ProcessRepository _repo = new ProcessRepository();

  BehaviorSubject<ProcessModel> _processBloc = BehaviorSubject<ProcessModel>();
  Stream<ProcessModel> get topicStream$ => _processBloc.stream;

  loaddata(BuildContext context) async{
    try{
      _processBloc.add(ProcessModel(status: Status.loading));
      _processBloc.add(ProcessModel(status: Status.loaded, rows: await _repo.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _processBloc.add(ProcessModel(status: Status.error, msg: '$e'));
    }
  }

  insertRow(BuildContext context){
    _processBloc.value.rows.forEach((element)=>element.edit=false);
    _processBloc.value.rows.insert(0, Process(
      id: 0,
      active: true,
      allcmp: false,
      edit: true,
      kind: 1,
      recon: false,
      title: '',
      token: readToken(context)
    ));
    _processBloc.add(_processBloc.value);
  }

  Future<bool> saveData(BuildContext context, Process obj) async{
    if (obj.title.isEmpty){
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان فرآیند مشخص نشده است');
      return false;
    }
    else
      try{
        showWaiting(context);
        obj.token = readToken(context);
        int _id = await _repo.save(obj);
        _processBloc.value.rows.forEach((element) {
          if (element.id == obj.id){
            element.id = _id;
            element.edit = false;
          }
        });
        _processBloc.add(_processBloc.value);
        hideWaiting(context);
        return true;
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
        return false;
      }
  }

  changeKind(int id, int val){
    _processBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.kind = val;
    });
    _processBloc.add(_processBloc.value);
  }

  changeActive(BuildContext context, int id, bool val){
    _processBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.active = val;
        if (! element.edit)
          await saveData(context, element);
      }
    });
    _processBloc.add(_processBloc.value);
  }

  changeRecon(BuildContext context, int id, bool val){
    _processBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.recon = val;
        if (! element.edit)
          await saveData(context, element);
      }
    });
    _processBloc.add(_processBloc.value);
  }

  changeAllCmp(BuildContext context, int id, bool val){
    _processBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.allcmp = val;
        if (! element.edit)
          await saveData(context, element);
      }
    });
    _processBloc.add(_processBloc.value);
  }

  delProcess(BuildContext context, Process obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف فرآیند ${obj.title} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delete(obj);
        _processBloc.value.rows.removeWhere((element)=> element.id==obj.id);
        _processBloc.add(_processBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  editRow(int id){
    _processBloc.value.rows.forEach((element) {
      element.edit = element.id == id;
    });
    _processBloc.add(_processBloc.value);
  }

  loadSteps(BuildContext context, int id) async{
    _processBloc.value.rows.forEach((element) {
      element.showDetail = element.id == id && !element.showDetail;
    });
    _processBloc.add(_processBloc.value);
  }
}