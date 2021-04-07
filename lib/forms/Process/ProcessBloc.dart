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
class PrcStepModel{
  Status status;
  List<Prcstep> rows;
  String msg;

  PrcStepModel({@required this.status, this.rows, this.msg});
}
class PrcStepDocumentModel{
  Status status;
  List<PrcStepDocument> rows;
  String msg;

  PrcStepDocumentModel({@required this.status, this.rows, this.msg});
}

class ProcessBloc{
  ProcessRepository _repo = new ProcessRepository();

  BehaviorSubject<ProcessModel> _processBloc = BehaviorSubject<ProcessModel>();
  Stream<ProcessModel> get processStream$ => _processBloc.stream;

  BehaviorSubject<PrcStepModel> _prcStepBloc = BehaviorSubject<PrcStepModel>();
  Stream<PrcStepModel> get prcStepStream$ => _prcStepBloc.stream;

  BehaviorSubject<PrcStepDocumentModel> _prcStepDocuemtnBloc = BehaviorSubject<PrcStepDocumentModel>();
  Stream<PrcStepDocumentModel> get prcStepDocuemtnStream$ => _prcStepDocuemtnBloc.stream;

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

  loadSteps(BuildContext context, int id){
    _processBloc.value.rows.forEach((element) async{
      element.showDetail = element.id == id && !element.showDetail;
      if (element.showDetail){
        try{
          _prcStepBloc.add(PrcStepModel(status: Status.loading));
          _prcStepBloc.add(PrcStepModel(status: Status.loaded, rows: await _repo.loadStep(readToken(context), id)));
        }
        catch(e){
          analyzeError(context, '$e');
          _prcStepBloc.add(PrcStepModel(status: Status.error, msg: '$e'));
        }
      }
    });
    _processBloc.add(_processBloc.value);
  }

  newStep(BuildContext context, int processid){
     _prcStepBloc.value.rows.forEach((element)=>element.edit=false);
     _prcStepBloc.value.rows.add(Prcstep(
      processid: processid,
      id: 0,
      active: true,
      title: '',
      kind: 1,
      length: 0,
      startprevend: false,
      edit: true,
      restart: false,
      sms: false,
      err27: false,
      token: readToken(context)
    ));
    _processBloc.add(_processBloc.value);
  }

  Future<bool> saveStep(BuildContext context, Prcstep obj) async{
    if (obj.title.isEmpty){
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان مرحله مشخص نشده است');
      return false;
    }
    else if (obj.length == 0){
      myAlert(context: context, title: 'مقادیر اجباری', message: 'مدت مجاز مشخص نشده است');
      return false;
    }
    else
      try{
        showWaiting(context);
        obj.token = readToken(context);
        int _id = await _repo.saveStep(obj);
        _prcStepBloc.value.rows.forEach((element) {
          if (element.id == obj.id){
            element.id = _id;
            element.edit = false;
          }
        });
        var len = _prcStepBloc.value.rows.reduce((value, element) => Prcstep(length: value.length+element.length)).length;
        _processBloc.value.rows.where((element) => element.id==obj.processid).first.duration=len;
        _prcStepBloc.add(_prcStepBloc.value);
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

  stepActive(BuildContext context, int id, bool val){
    _prcStepBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.active = val;
        if (! element.edit)
          await saveStep(context, element);
      }
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  stepstartprevend(BuildContext context, int id, bool val){
    _prcStepBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.startprevend = val;
        if (! element.edit)
          await saveStep(context, element);
      }
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  steprestart(BuildContext context, int id, bool val){
    _prcStepBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.restart = val;
        if (! element.edit)
          await saveStep(context, element);
      }
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  stepsms(BuildContext context, int id, bool val){
    _prcStepBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.sms = val;
        if (! element.edit)
          await saveStep(context, element);
      }
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  steperr27(BuildContext context, int id, bool val){
    _prcStepBloc.value.rows.forEach((element) async {
      if (element.id == id){
        element.err27 = val;
        if (! element.edit)
          await saveStep(context, element);
      }
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  stepKind(int id, int val){
    _prcStepBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.kind = val;
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  editStep(int id){
    _prcStepBloc.value.rows.forEach((element) {
      element.edit = element.id == id;
    });
    _prcStepBloc.add(_prcStepBloc.value);
  }
  delStep(BuildContext context, Prcstep obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف مرحله ${obj.title} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delStep(obj);
        _prcStepBloc.value.rows.removeWhere((element)=> element.id==obj.id);
        _prcStepBloc.add(_prcStepBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }
  
  loadStepDocuemnt(BuildContext context, int processid, int stepid) async{
    try{
      _prcStepDocuemtnBloc.add(PrcStepDocumentModel(status: Status.loading));
      _prcStepDocuemtnBloc.add(PrcStepDocumentModel(status: Status.loaded, rows: await _repo.loadStepDocument(readToken(context), processid, stepid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _prcStepDocuemtnBloc.add(PrcStepDocumentModel(status: Status.error, msg: '$e'));
    }
  }
  Future<bool> saveStepDocument(BuildContext context, PrcStepDocument obj) async{
    try{
      showWaiting(context);
      obj.token = readToken(context);
      obj.id = await _repo.saveStepDocument(obj);
      obj.edit = false;
      _prcStepDocuemtnBloc.add(_prcStepDocuemtnBloc.value);
      hideWaiting(context);
      return true;
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
      return false;
    }
  }
  searchDocument(String val){
    _prcStepDocuemtnBloc.value.rows.forEach((element) {element.search = element.documentname.contains(val);});
    _prcStepDocuemtnBloc.add(_prcStepDocuemtnBloc.value);
  }
  changeStepDocumentKind(int id, int val){
    _prcStepDocuemtnBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.kind = val;
    });
    _prcStepDocuemtnBloc.add(_prcStepDocuemtnBloc.value);
  }
  insetStepDocument(int processid, int stepid){
    _prcStepDocuemtnBloc.value.rows.forEach((element)=>element.edit=false);
    _prcStepDocuemtnBloc.value.rows.insert(0, PrcStepDocument(processid: processid, stepid: stepid, id: 0, documentid: 0, documentname: '', edit: true));
    _prcStepDocuemtnBloc.add(_prcStepDocuemtnBloc.value);
  }
  editStepDocument(int id){
    _prcStepDocuemtnBloc.value.rows.forEach((element)=>element.edit=element.id==id);
    _prcStepDocuemtnBloc.add(_prcStepDocuemtnBloc.value);
  }
  delStepDocumetn(BuildContext context, PrcStepDocument obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.documentname} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delStepDocument(obj);
        _prcStepDocuemtnBloc.value.rows.removeWhere((element)=> element.id==obj.id);
        _prcStepDocuemtnBloc.add(_prcStepDocuemtnBloc.value);
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