import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class InspectionModel{
  Status status;
  List<Inspection> rows;
  String msg;

  InspectionModel({@required this.status, this.rows, this.msg});
}
class InspectiongovModel{
  Status status;
  List<Inspectiongov> rows;
  String msg;

  InspectiongovModel({@required this.status, this.rows, this.msg});
}
class InspectioncompanyModel{
  Status status;
  List<Inspectioncompany> rows;
  String msg;

  InspectioncompanyModel({@required this.status, this.rows, this.msg});
}
class InspectioncompanypeopModel{
  Status status;
  List<Inspectioncompanypeop> rows;
  String msg;

  InspectioncompanypeopModel({@required this.status, this.rows, this.msg});
}

class InspectionBloc{
  InspectionRepository _repository = InspectionRepository();

  BehaviorSubject<InspectionModel> _inspBloc = BehaviorSubject<InspectionModel>.seeded(InspectionModel(status: Status.loading));
  Stream<InspectionModel> get inspStream$ => _inspBloc.stream;

  BehaviorSubject<InspectioncompanyModel> _inspcompanyBloc = BehaviorSubject<InspectioncompanyModel>.seeded(InspectioncompanyModel(status: Status.loading));
  Stream<InspectioncompanyModel> get inspcompanyStream$ => _inspcompanyBloc.stream;

  BehaviorSubject<InspectiongovModel> _inspgovBloc = BehaviorSubject<InspectiongovModel>.seeded(InspectiongovModel(status: Status.loading));
  Stream<InspectiongovModel> get inspgovStream$ => _inspgovBloc.stream;

  BehaviorSubject<InspectioncompanypeopModel> _inspcmppeopBloc = BehaviorSubject<InspectioncompanypeopModel>.seeded(InspectioncompanypeopModel(status: Status.loading));
  Stream<InspectioncompanypeopModel> get inspcmppeopStream$ => _inspcmppeopBloc.stream;

  load(BuildContext context, int cmp) async{
    try{
      _inspBloc.add(InspectionModel(status: Status.loading));
      _inspBloc.add(InspectionModel(status: Status.loaded, rows: await _repository.loadInspection(readToken(context), cmp)));
    }
    catch(e){
      analyzeError(context, '$e');
      _inspBloc.add(InspectionModel(status: Status.error, msg: '$e'));
    }
  }

  delInspection(BuildContext context, Inspection insp){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${insp.name} می باشید؟', yesclick: () async{
      try{
        insp.token = readToken(context);
        await _repository.delInspection(insp);
        _inspBloc.value.rows.removeWhere((element) => element.id==insp.id);
        _inspBloc.add(_inspBloc.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    });
  }

  saveInspection(BuildContext context, Inspection insp) async{
    try{
      showWaiting(context);
      insp.token = readToken(context);
      int _id = await _repository.saveInspection(insp);
      bool nv = true;
      _inspBloc.value.rows.forEach((element) {
        if (element.id == insp.id)
          nv = false;
      });
      if (nv){
        insp.id = _id;
        _inspBloc.value.rows.insert(0, insp);
      }
      _inspBloc.add(_inspBloc.value);
      hideWaiting(context);
      Navigator.pop(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }

  setMode(BuildContext context, int id, {bool company = false, bool gov = false}){
    _inspBloc.value.rows.forEach((element) {
      if (gov && element.id == id){
        element.gov = !element.gov;
        if (element.gov)
          loadgov(context, id);
      }
      else
        element.gov = false;
      if (company&& element.id == id){
        element.compay = !element.compay;
        if (element.compay)
          loadCompany(context, id);
      }
      else  
        element.compay = false;
    });
    _inspBloc.add(_inspBloc.value);
  }

  loadgov(BuildContext context, int insid) async{
    try{
      _inspgovBloc.add(InspectiongovModel(status: Status.loading));
      _inspgovBloc.add(InspectiongovModel(status: Status.loaded, rows: await _repository.loadInspectionGov(readToken(context), insid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _inspgovBloc.add(InspectiongovModel(status: Status.error, msg: '$e'));
    }
  }

  delInspectiongov(BuildContext context, Inspectiongov obj){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.govname} می باشید؟', yesclick: () async{
      try{
        obj.token = readToken(context);
        await _repository.delInspectionGov(obj);
        _inspgovBloc.value.rows.removeWhere((element) => element.govid==obj.govid);
        _inspgovBloc.add(_inspgovBloc.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    });
  }

  saveInspectiongov(BuildContext context, Inspectiongov obj) async{
    try{
      obj.token = readToken(context);
      if (obj.note.trim() != "addnew")
        if (obj.note.trim().isEmpty){
          myAlert(context: context, title: 'مقادیر اجباری', message: 'توضیحات مشخص نشده است');
          return;
        }
        else{
          showWaiting(context);
          await _repository.saveInspectionGov(obj);
          hideWaiting(context);
        }
      else 
        obj.note = "";
      bool nv = true;
      _inspgovBloc.value.rows.forEach((element) {
        if (element.govid== obj.govid){
          nv = false;
          element.edit = !element.edit;
        }
      });
      if (nv){
        _inspgovBloc.value.rows.insert(0, obj);
      }
      _inspgovBloc.add(_inspgovBloc.value);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }

  editModeInspectionGov(Inspectiongov gov){
    _inspgovBloc.value.rows.forEach((element) {
      if (element.govid == gov.govid)
        element.edit = !element.edit;
      else
        element.edit = false;
    });
    _inspgovBloc.add(_inspgovBloc.value);
  }

  loadCompany(BuildContext context, int insid) async{
    try{
      _inspcompanyBloc.add(InspectioncompanyModel(status: Status.loading));
      _inspcompanyBloc.add(InspectioncompanyModel(status: Status.loaded, rows: await _repository.loadInspectionCompany(readToken(context), insid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _inspcompanyBloc.add(InspectioncompanyModel(status: Status.error, msg: '$e'));
    }
  }

  delInspectioncompany(BuildContext context, Inspectioncompany obj){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${obj.cmpname} می باشید؟', yesclick: () async{
      try{
        obj.token = readToken(context);
        await _repository.delInspectionCompany(obj);
        _inspcompanyBloc.value.rows.removeWhere((element) => element.cmpid==obj.cmpid);
        _inspcompanyBloc.add(_inspcompanyBloc.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    });
  }

  saveInspectioncompany(BuildContext context, Inspectioncompany obj) async{
    try{
      obj.token = readToken(context);
      if (obj.note.trim() != "addnew")
        if (obj.note.trim().isEmpty){
          myAlert(context: context, title: 'مقادیر اجباری', message: 'توضیحات مشخص نشده است');
          return;
        }
        else{
          showWaiting(context);
          await _repository.saveInspectionCompany(obj);
          hideWaiting(context);
        }
      else 
        obj.note = "";
      bool nv = true;
      _inspcompanyBloc.value.rows.forEach((element) {
        if (element.cmpid == obj.cmpid){
          nv = false;
          element.edit = !element.edit;
        }
      });
      if (nv){
        _inspcompanyBloc.value.rows.insert(0, obj);
      }
      _inspcompanyBloc.add(_inspcompanyBloc.value);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }

  editModeInspectionCompany(BuildContext context,Inspectioncompany com, {bool edit=false, bool peop=false, bool emp=false}){
    _inspcompanyBloc.value.rows.forEach((element) {
      if (edit){
        if (element.cmpid == com.cmpid)
          element.edit = !element.edit;
        else
          element.edit = false;
        element.peop = false;
        element.emp = false;
      }
      if (peop){
        if (element.cmpid == com.cmpid)
          element.peop = !element.peop;
        else
          element.peop = false;
        element.edit = false;
        element.emp = false;
      }
      if (emp){
        if (element.cmpid == com.cmpid)
          element.emp = !element.emp;
        else
          element.emp = false;
        element.peop = false;
        element.edit = false;
      }
      if (peop && element.peop)
        loadCompanyPeop(context, com.insid, com.cmpid, 2);
      if (emp && element.emp)
        loadCompanyPeop(context, com.insid, com.cmpid, 1);
    });
    _inspcompanyBloc.add(_inspcompanyBloc.value);
  }

  loadCompanyPeop(BuildContext context, int insid, int cmpid, int kind) async{
    try{
      _inspcmppeopBloc.add(InspectioncompanypeopModel(status: Status.loading));
      _inspcmppeopBloc.add(InspectioncompanypeopModel(status: Status.loaded, rows: await _repository.loadInspectionCompanyPeop(readToken(context), insid, cmpid, kind)));
    }
    catch(e){
      analyzeError(context, '$e');
      _inspcmppeopBloc.add(InspectioncompanypeopModel(status: Status.error, msg: '$e'));
    }
  }

  manageCompanyPeop(BuildContext context, Inspectioncompanypeop peop, {bool save=false}) async{
    peop.token = readToken(context);
    if (peop.kind==1)
      try{
        if (peop.valid)
          await _repository.delInspectionCompanyPeop(peop);
        else
          await _repository.saveInspectionCompanyPeop(peop);
          _inspcmppeopBloc.value.rows.forEach((element){
            if (element.peopid==peop.peopid)
              element.valid = !element.valid;
          });
          _inspcmppeopBloc.add(_inspcmppeopBloc.value);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    else if (save){
      try{
        await _repository.saveInspectionCompanyPeop(peop);
        bool _nv=true;
        _inspcmppeopBloc.value.rows.forEach((element){
          if (element.peopid==peop.peopid)
            _nv=false;
        });
        if (_nv)
          _inspcmppeopBloc.value.rows.insert(0, Inspectioncompanypeop(insid: peop.insid, cmpid: peop.cmpid, peopid: peop.peopid, peopfamily: peop.peopfamily, kind: 2));
        _inspcmppeopBloc.add(_inspcmppeopBloc.value);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    }
    else
      confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${peop.peopfamily} می باشید؟', yesclick: () async{
        try{
          await _repository.delInspectionCompanyPeop(peop);
          _inspcmppeopBloc.value.rows.removeWhere((element) => element.peopid==peop.peopid);
          _inspcmppeopBloc.add(_inspcmppeopBloc.value);
        }
        catch(e){
          analyzeError(context, '$e');
        }
        Navigator.pop(context);
      });
  }
}