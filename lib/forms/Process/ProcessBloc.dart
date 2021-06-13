import 'package:flutter/material.dart';
import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';
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
class PrcStepIncomeModel{
  Status status;
  List<PrcStepIncome> rows;
  String msg;

  PrcStepIncomeModel({@required this.status, this.rows, this.msg});
}
class PrcCompanyModel{
  Status status;
  List<PrcCompany> rows;
  String msg;

  PrcCompanyModel({@required this.status, this.rows, this.msg});
}
class PrcCmpRasteModel{
  Status status;
  List<PrcCmpRaste> rows;
  String msg;

  PrcCmpRasteModel({@required this.status, this.rows, this.msg});
}
class PrcStepCourseModel{
  Status status;
  List<PrcStepCourse> rows;
  String msg;

  PrcStepCourseModel({@required this.status, this.rows, this.msg});
}

class ProcessBloc{
  ProcessRepository _repo = new ProcessRepository();

  BehaviorSubject<ProcessModel> _processBloc = BehaviorSubject<ProcessModel>();
  Stream<ProcessModel> get processStream$ => _processBloc.stream;

  BehaviorSubject<PrcStepModel> _prcStepBloc = BehaviorSubject<PrcStepModel>();
  Stream<PrcStepModel> get prcStepStream$ => _prcStepBloc.stream;

  BehaviorSubject<PrcStepDocumentModel> _prcStepDocuemtnBloc = BehaviorSubject<PrcStepDocumentModel>();
  Stream<PrcStepDocumentModel> get prcStepDocuemtnStream$ => _prcStepDocuemtnBloc.stream;

  BehaviorSubject<PrcStepIncomeModel> _prcStepIncomeBloc = BehaviorSubject<PrcStepIncomeModel>();
  Stream<PrcStepIncomeModel> get prcStepIncomeStream$ => _prcStepIncomeBloc.stream;

  BehaviorSubject<PrcStepCourseModel> _prcStepCourseBloc = BehaviorSubject<PrcStepCourseModel>();
  Stream<PrcStepCourseModel> get prcStepCourseStream$ => _prcStepCourseBloc.stream;

  BehaviorSubject<PrcCompanyModel> _prcCompanyBloc = BehaviorSubject<PrcCompanyModel>();
  Stream<PrcCompanyModel> get prcCompanyStream$ => _prcCompanyBloc.stream;

  BehaviorSubject<PrcCmpRasteModel> _prcCmpRasteBloc = BehaviorSubject<PrcCmpRasteModel>();
  Stream<PrcCmpRasteModel> get prcCmpRasteStream$ => _prcCmpRasteBloc.stream;

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
      element.showComnpany = false;
      element.showStep = element.id == id && !element.showStep;
      if (element.showStep){
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
      kind: 1,
      length: 0,
      startprevend: false,
      edit: true,
      restart: false,
      sms: false,
      err27: false,
      token: readToken(context)
    ));
    _prcStepBloc.add(_prcStepBloc.value);
  }

  Future<bool> saveStep(BuildContext context, Prcstep obj) async{
    if (obj.length == 0){
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
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف مرحله ${obj.kindName()} می باشید؟', yesclick: () async{
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
  insertStepDocument(int processid, int stepid){
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

  loadStepIncome(BuildContext context, int processid, int stepid) async{
    try{
      _prcStepIncomeBloc.add(PrcStepIncomeModel(status: Status.loading));
      _prcStepIncomeBloc.add(PrcStepIncomeModel(status: Status.loaded, rows: await _repo.loadStepIncome(readToken(context), processid, stepid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _prcStepIncomeBloc.add(PrcStepIncomeModel(status: Status.error, msg: '$e'));
    }
  }
  Future<bool> saveStepIncome(BuildContext context, PrcStepIncome obj) async{
    try{
      showWaiting(context);
      obj.token = readToken(context);
      await _repo.saveStepIncome(obj);
      _prcStepIncomeBloc.add(_prcStepIncomeBloc.value);
      hideWaiting(context);
      return true;
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
      return false;
    }
  }
  insertStepIncome(int processid, int stepid){
    _prcStepIncomeBloc.value.rows.insert(0, PrcStepIncome(processid: processid, stepid: stepid, incomeid: 0));
    _prcStepIncomeBloc.add(_prcStepIncomeBloc.value);
  }
  delStepIncome(BuildContext context, PrcStepIncome obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.incomename} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delStepIncome(obj);
        _prcStepIncomeBloc.value.rows.removeWhere((element)=> element.incomeid==obj.incomeid);
        _prcStepIncomeBloc.add(_prcStepIncomeBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  loadCompany(BuildContext context, int id){
    _processBloc.value.rows.forEach((element) async{
      element.showStep = false;
      element.showComnpany = element.id == id && !element.showComnpany;
      if (element.showComnpany){
        try{
          _prcCompanyBloc.add(PrcCompanyModel(status: Status.loading));
          _prcCompanyBloc.add(PrcCompanyModel(status: Status.loaded, rows: await _repo.loadCompany(readToken(context), id)));
        }
        catch(e){
          analyzeError(context, '$e');
          _prcCompanyBloc.add(PrcCompanyModel(status: Status.error, msg: '$e'));
        }
      }
    });
    _processBloc.add(_processBloc.value);
  }
  newCompany(BuildContext context, int processid){
    if (_prcCompanyBloc.value.rows.where((element) => element.cmpid==0).length == 0)
      _prcCompanyBloc.value.rows.add(PrcCompany(
        processid: processid,
        cmpid: 0,
        allraste: false,
        token: readToken(context)
      ));
    _prcCompanyBloc.add(_prcCompanyBloc.value);
  }
  Future<bool> saveCompany(BuildContext context, PrcCompany obj) async{
    if (obj.cmpid==0){
      myAlert(context: context, title: 'مقادیر اجباری', message: 'اتحادیه مشخص نشده است');
      return false;
    }
    else
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.saveCompany(obj);
        _prcCompanyBloc.add(_prcCompanyBloc.value);
        hideWaiting(context);
        return true;
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
        return false;
      }
  }
  delCompany(BuildContext context, PrcCompany obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.cmpname} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delCompany(obj);
        _prcCompanyBloc.value.rows.removeWhere((element)=> element.cmpid==obj.cmpid);
        _prcCompanyBloc.add(_prcCompanyBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  loadCmpRaste(BuildContext context, int processid, int cmpid) async{
    try{
      _prcCmpRasteBloc.add(PrcCmpRasteModel(status: Status.loading));
      _prcCmpRasteBloc.add(PrcCmpRasteModel(status: Status.loaded, rows: await _repo.loadCmpRaste(readToken(context), processid, cmpid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _prcCmpRasteBloc.add(PrcCmpRasteModel(status: Status.error, msg: '$e'));
    }
  }
  newCmpRaste(BuildContext context, int processid, int cmpid){
    if (_prcCmpRasteBloc.value.rows.where((element) => element.cmpid==0).length == 0)
      _prcCmpRasteBloc.value.rows.add(PrcCmpRaste(
        processid: processid,
        cmpid: cmpid,
        token: readToken(context)
      ));
    _prcCmpRasteBloc.add(_prcCmpRasteBloc.value);
  }
  Future<bool> saveCmpRaste(BuildContext context, PrcCmpRaste obj) async{
    if (obj.hisic==0){
      myAlert(context: context, title: 'مقادیر اجباری', message: 'رسته مشخص نشده است');
      return false;
    }
    else
      try{
        showWaiting(context);
        obj.token = readToken(context);
        obj.id = await _repo.saveCmpRaste(obj);
        _prcCmpRasteBloc.add(_prcCmpRasteBloc.value);
        hideWaiting(context);
        return true;
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
        return false;
      }
  }
  delCmpRaste(BuildContext context, PrcCmpRaste obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.isicname} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delCmpRaste(obj);
        _prcCmpRasteBloc.value.rows.removeWhere((element)=> element.id==obj.id);
        _prcCmpRasteBloc.add(_prcCmpRasteBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  loadStepCourse(BuildContext context, int processid, int stepid) async{
    try{
      _prcStepCourseBloc.add(PrcStepCourseModel(status: Status.loading));
      _prcStepCourseBloc.add(PrcStepCourseModel(status: Status.loaded, rows: await _repo.loadStepCourse(readToken(context), processid, stepid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _prcStepCourseBloc.add(PrcStepCourseModel(status: Status.error, msg: '$e'));
    }
  }
  Future<bool> saveStepCourse(BuildContext context, PrcStepCourse obj) async{
    try{
      showWaiting(context);
      obj.token = readToken(context);
      await _repo.saveStepCourse(obj);
      obj.edit=false;
      _prcStepCourseBloc.add(_prcStepCourseBloc.value);
      hideWaiting(context);
      return true;
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
      return false;
    }
  }
  insertStepCourse(int processid, int stepid){
    _prcStepCourseBloc.value.rows.insert(0, PrcStepCourse(processid: processid, stepid: stepid, courseid: 0, edit: true));
    _prcStepCourseBloc.add(_prcStepCourseBloc.value);
  }
  delStepCourse(BuildContext context, PrcStepCourse obj) async{
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.coursetitle} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        obj.token = readToken(context);
        await _repo.delStepCourse(obj);
        _prcStepCourseBloc.value.rows.removeWhere((element)=> element.courseid == obj.courseid && element.kind==obj.kind);
        _prcStepCourseBloc.add(_prcStepCourseBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }
  stepCoursechangeKind(PrcStepCourse obj, int kind){
    obj.kind = kind;
    _prcStepCourseBloc.add(_prcStepCourseBloc.value);
  }
  editStepCourse(PrcStepCourse obj){
    obj.edit = true;
    _prcStepCourseBloc.add(_prcStepCourseBloc.value);
  }
}