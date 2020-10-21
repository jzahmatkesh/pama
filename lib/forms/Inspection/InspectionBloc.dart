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
      showWaiting(context);
      obj.token = readToken(context);
      await _repository.saveInspectionGov(obj);
      bool nv = true;
      _inspgovBloc.value.rows.forEach((element) {
        if (element.govid== obj.govid)
          nv = false;
      });
      if (nv){
        _inspgovBloc.value.rows.insert(0, obj);
      }
      _inspgovBloc.add(_inspgovBloc.value);
      hideWaiting(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
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
      showWaiting(context);
      obj.token = readToken(context);
      await _repository.saveInspectionCompany(obj);
      bool nv = true;
      _inspcompanyBloc.value.rows.forEach((element) {
        if (element.cmpid == obj.cmpid)
          nv = false;
      });
      if (nv){
        _inspcompanyBloc.value.rows.insert(0, obj);
      }
      _inspcompanyBloc.add(_inspcompanyBloc.value);
      hideWaiting(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }
}