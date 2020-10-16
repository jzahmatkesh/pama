import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class ViolationModel{
  Status status;
  List<Violation> rows;
  String msg;

  ViolationModel({this.status, this.rows, this.msg});
}

class ViolationBloc{
  ViolationRepository _repository = new ViolationRepository();
  
  BehaviorSubject<ViolationModel> _violationbloc = BehaviorSubject<ViolationModel>.seeded(ViolationModel(status: Status.loading));
  Stream<ViolationModel> get violationStream$ => _violationbloc.stream;

  loadData(BuildContext context) async{
    try{
      _violationbloc.add(ViolationModel(status: Status.loading));
      _violationbloc.add(ViolationModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _violationbloc.add(ViolationModel(status: Status.error, msg: '$e'));
    }
  }

  saveViolation(BuildContext context, Violation violation) async{
    if (violation.name.trim().isEmpty) 
      myAlert(context: context, title: "خطا", message: "عنوان تخلف مشخص نشده است");
    else
      try{
        showWaiting(context);
        violation.token = readToken(context);
        int id = await _repository.save(violation);
        bool nw = true;
        _violationbloc.value.rows.forEach((element) {
          if (element.id == id){
            element.editing = false;
            nw = false;
          }
        });
        if (nw)
          _violationbloc.value.rows.forEach((element) {
            if (element.id == 0){
              element.editing = false;
              element.id = id;
              element.name = violation.name;
              nw = false;
            }
          });
        _violationbloc.add(_violationbloc.value);
        myAlert(context: context, title: "ذخیره", message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.green);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  newViolation(BuildContext context){
    _violationbloc.value.rows.insert(0, new Violation(id: 0, name: ""));
    _violationbloc.add(_violationbloc.value);
  }

  delViolation(BuildContext context, Violation violation){
    confirmMessage(context, 'تایید حذف', "آیا مایل به حذف ${violation.name} می باشید؟", yesclick: () async{
      try{
        showWaiting(context);
        violation.token = readToken(context);
        await _repository.delete(violation);
        _violationbloc.value.rows.removeWhere((element) => element.id == violation.id);
        _violationbloc.add(_violationbloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  editMode(Violation vio){
    _violationbloc.value.rows.forEach((element) {
      element.editing = element.id == vio.id;
    });
    _violationbloc.add(_violationbloc.value);
  }
}