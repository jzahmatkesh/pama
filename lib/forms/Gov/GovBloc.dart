import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class GovModel{
  Status status;
  List<Gov> rows;
  String msg;

  GovModel({this.status, this.rows, this.msg});
}

class GovBloc{
  GovRepository _repository = new GovRepository();
  
  BehaviorSubject<GovModel> _govbloc = BehaviorSubject<GovModel>.seeded(GovModel(status: Status.loading));
  Stream<GovModel> get govStream$ => _govbloc.stream;
  List<Gov> get govlists$ => _govbloc.value.rows;

  loadData(BuildContext context) async{
    try{
      _govbloc.add(GovModel(status: Status.loading));
      _govbloc.add(GovModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _govbloc.add(GovModel(status: Status.error, msg: '$e'));
    }
  }

  saveGov(BuildContext context, Gov gov) async{
    if (gov.name.trim().isEmpty) 
      myAlert(context: context, title: "خطا", message: "عنوان بانک مشخص نشده است");
    else
      try{
        showWaiting(context);
        gov.token = readToken(context);
        int id = await _repository.save(gov);
        bool nw = true;
        _govbloc.value.rows.forEach((element) {
          if (element.id == id)
            nw = false;
        });
        if (nw)
          _govbloc.value.rows.insert(0, gov);
        _govbloc.add(_govbloc.value);
        myAlert(context: context, title: "ذخیره", message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.green);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  delGov(BuildContext context, Gov gov){
    confirmMessage(context, 'تایید حذف', "آیا مایل به حذف ${gov.name} می باشید؟", yesclick: () async{
      try{
        showWaiting(context);
        gov.token = readToken(context);
        await _repository.delete(gov);
        _govbloc.value.rows.removeWhere((element) => element.id == gov.id);
        _govbloc.add(_govbloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }
}