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

class InspectionBloc{
  InspectionRepository _repository = InspectionRepository();

  BehaviorSubject<InspectionModel> _inspBloc = BehaviorSubject<InspectionModel>.seeded(InspectionModel(status: Status.loading));
  Stream<InspectionModel> get inspStream$ => _inspBloc.stream;

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
      if (gov && element.id == id)
        element.gov = !element.gov;
      else
        element.gov = false;
      if (company&& element.id == id)
        element.compay = !element.compay;
      else  
        element.compay = false;
    });
    _inspBloc.add(_inspBloc.value);
  }
}