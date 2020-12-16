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

  search(String val){
    _nolicenseBloc.value.rows.forEach((element) {
      element.inSearch = element.cmpname.contains(val) || element.nationalid.contains(val) || element.name.contains(val) || element.family.contains(val) || element.tel.contains(val) || element.post.contains(val) || element.nosazicode.contains(val) || element.address.contains(val) || element.note.contains(val);
    });
    _nolicenseBloc.add(_nolicenseBloc.value);
  }

  saveNote(BuildContext context, Nolicense lcn) async{
    try{
      showWaiting(context);
      lcn.token = readToken(context);
      await _repository.saveNote(lcn);
      _nolicenseBloc.value.rows.forEach((element) {
        if (element.cmpid == lcn.cmpid && element.id == lcn.id){
          element.note = lcn.note;
        }
      });
      _nolicenseBloc.add(_nolicenseBloc.value);
      hideWaiting(context);
      Navigator.pop(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }

  Future<Map<String, dynamic>> checkNationlID(BuildContext context, String national) async{
    try{
      PeopleRepository _peop = PeopleRepository();
      List<People> _rows = await _peop.checkNationalID(readToken(context), national, "", "");
      if (_rows.length > 0)
        return {'name': _rows[0].name, 'family': _rows[0].family};
    }
    catch(e){
      analyzeError(context, '$e');
    }
    return null;
  }
}

class ExcelBloc{
  ExcelBloc({@required this.rows}){
    this.rows.forEach((element) {
      value.add(ExcelRow(check: false, cells: element));
    });
    _rows.add(value);
  }

  final List<List<dynamic>> rows;
  NoLicenseRepository _repository = NoLicenseRepository();

  BehaviorSubject<List<ExcelRow>> _rows = BehaviorSubject<List<ExcelRow>>.seeded([]);
  Stream<List<ExcelRow>> get stream$ => _rows.stream;
  List<ExcelRow> get value => _rows.value;

  checkRow(int idx, bool val, {String error}){
    if (idx==0)
      value.forEach((element)=>element.check=val);
    else
      value[idx].check = val;
    value[idx].error = error;
    _rows.add(value);
  }
  imported(int idx){
    value[idx].imported = true;
    _rows.add(value);
  }

  Future<bool> exportToDB({BuildContext context, String api, Nolicense lcn}) async{
    try{
      await _repository.save(lcn);
      return true;
    }
    catch(e){
      analyzeError(context, '$e');
      return false;
    }
  }
}
