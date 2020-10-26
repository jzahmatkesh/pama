import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class NoLicenseModel{
  Status status;
  List<Nolicense> rows;
  String msg;

  NoLicenseModel({@required this.status, this.rows, this.msg});
}

class NoLicenseBloc{
  NoLicenseRepository _repository = NoLicenseRepository();

  BehaviorSubject<NoLicenseModel> _nolicenseBloc = BehaviorSubject<NoLicenseModel>();
  Stream<NoLicenseModel> get nolicenseStream$ => _nolicenseBloc.stream;

  load(BuildContext context, int cmpid) async{
    try{
      _nolicenseBloc.add(NoLicenseModel(status: Status.loading));
      _nolicenseBloc.add(NoLicenseModel(status: Status.loaded, rows: await _repository.load(readToken(context), cmpid) ));
    }
    catch(e){
      analyzeError(context, '$e');
      _nolicenseBloc.add(NoLicenseModel(status: Status.error, msg: '$e'));
    }
  }  

  save(BuildContext context, Nolicense lcn) async{
    try{
      showWaiting(context);
      lcn.token = readToken(context);
      int _id = await _repository.save(lcn);
      bool nv = true;
      _nolicenseBloc.value.rows.forEach((element) {
        if (element.id == lcn.id){
          nv = false;
        }
      });
      lcn.id = _id;
      if (nv)
        _nolicenseBloc.value.rows.insert(0, lcn);
      _nolicenseBloc.add(_nolicenseBloc.value);
      hideWaiting(context);
      Navigator.pop(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }  

  delete(BuildContext context, Nolicense lcn){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${lcn.name} ${lcn.family} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        lcn.token = readToken(context);
        await _repository.delete(lcn);
        _nolicenseBloc.value.rows.removeWhere((element) => element.id==lcn.id);
        _nolicenseBloc.add(_nolicenseBloc.value);
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
