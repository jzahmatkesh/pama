
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class IncomeModel{
  Status status;
  List<Income> rows;
  String msg;

  IncomeModel({@required this.status, this.rows, this.msg});
}
class IncomeShareModel{
  Status status;
  List<Incomeshare> rows;
  String msg;

  IncomeShareModel({@required this.status, this.rows, this.msg});
}
class IncomeHistoryModel{
  Status status;
  List<Incomehistory> rows;
  String msg;

  IncomeHistoryModel({@required this.status, this.rows, this.msg});
}
class IncomeCompanyModel{
  Status status;
  List<Incomecompany> rows;
  String msg;

  IncomeCompanyModel({@required this.status, this.rows, this.msg});
}
class IncomeCompanyRasteModel{
  Status status;
  List<Incomecompanyraste> rows;
  String msg;

  IncomeCompanyRasteModel({@required this.status, this.rows, this.msg});
}

class IncomeBloc{
  IncomeRepository _repo = new IncomeRepository();

  BehaviorSubject<IncomeModel> _incomBloc = BehaviorSubject<IncomeModel>();
  Stream<IncomeModel> get incomStream$ => _incomBloc.stream;

  BehaviorSubject<IncomeShareModel> _incomShareBloc = BehaviorSubject<IncomeShareModel>();
  Stream<IncomeShareModel> get incomShareStream$ => _incomShareBloc.stream;

  BehaviorSubject<IncomeHistoryModel> _incomHistoryBloc = BehaviorSubject<IncomeHistoryModel>();
  Stream<IncomeHistoryModel> get incomHistoryStream$ => _incomHistoryBloc.stream;

  BehaviorSubject<IncomeCompanyModel> _incomCompanyBloc = BehaviorSubject<IncomeCompanyModel>();
  Stream<IncomeCompanyModel> get incomCompanyStream$ => _incomCompanyBloc.stream;

  BehaviorSubject<IncomeCompanyRasteModel> _incomCompanyRasteBloc = BehaviorSubject<IncomeCompanyRasteModel>();
  Stream<IncomeCompanyRasteModel> get incomCompanyRasteStream$ => _incomCompanyRasteBloc.stream;

  loadIncome(BuildContext context) async{
    try{
      _incomBloc.add(IncomeModel(status: Status.loading));
      _incomBloc.add(IncomeModel(status: Status.loaded, rows: await _repo.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _incomBloc.add(IncomeModel(status: Status.error, msg: '$e'));
    }
  }

  newIncome(BuildContext context){
    _incomBloc.value.rows.forEach((element){element.edit=false;element.company=false;element.share=false;element.pricehistory=false;});
    _incomBloc.value.rows.insert(0, Income(id: 0, edit: true, active: false, refund: false, allcmp: false, epay: false, name: '', off: false));
    _incomBloc.add(_incomBloc.value);
  }

  saveIncome(BuildContext context, Income inc) async{
    if (inc.name.isEmpty)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان درآمد مشخص نشده است');
    else
      try{
        showWaiting(context);
        inc.token = readToken(context);
        int _id = await _repo.save(inc);
        _incomBloc.value.rows.forEach((element) {
          if (element.id == inc.id){
            element.id = _id;
            element.edit = false;
          }
        });
        _incomBloc.add(_incomBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  delIncome(BuildContext context, Income inc){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف درآمد ${inc.name} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        inc.token = readToken(context);
        await _repo.delete(inc);
        _incomBloc.value.rows.removeWhere((element)=> element.id==inc.id);
        _incomBloc.add(_incomBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  setRadio(BuildContext context, int id, {bool edit=false, bool act=false, bool epay=false, bool refund=false, bool off=false, bool allcmp=false}){
    _incomBloc.value.rows.forEach((element) async{
      if (element.id == id){
        if (edit)
          element.edit = !element.edit;
        if (act)
          element.active = !element.active;
        if (epay)
          element.epay = !element.epay;
        if (refund)
          element.refund = !element.refund;
        if (off)
          element.off = !element.off;
        if (allcmp)
          element.allcmp = !element.allcmp;
        element.token = readToken(context);
        if (element.id > 0 && !edit)
          await _repo.save(element);
      }
    });
    _incomBloc.add(_incomBloc.value);
  }



  loadIncomeShare(BuildContext context, int incid) async{
    try{
      _incomBloc.value.rows.forEach((element) {
        if (element.id == incid)
          element.share = !element.share;
        element.pricehistory = false;
        element.company = false;
      });
      _incomBloc.add(_incomBloc.value);
      _incomShareBloc.add(IncomeShareModel(status: Status.loading));
      _incomShareBloc.add(IncomeShareModel(status: Status.loaded, rows: await _repo.loadShare(readToken(context), incid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _incomShareBloc.add(IncomeShareModel(status: Status.error, msg: '$e'));
    }
  }

  saveIncomeShare(BuildContext context, Incomeshare shr) async{
    if (shr.name.isEmpty && shr.id > 2)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان بستانکار مشخص نشده است');
    else
      try{
        showWaiting(context);
        shr.token = readToken(context);
        int _id = await _repo.saveShare(shr);
        _incomShareBloc.value.rows.forEach((element) {
          if (element.id == shr.id){
            element.id = _id;
            element.edit = false;
          }
        });
        _incomShareBloc.add(_incomShareBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  delIncomeShare(BuildContext context, Incomeshare shr){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${shr.name} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        shr.token = readToken(context);
        await _repo.deleteShare(shr);
        _incomShareBloc.value.rows.removeWhere((element)=> element.id==shr.id);
        _incomShareBloc.add(_incomShareBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  editIncomeShare(int id){
    _incomShareBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.edit = true;
      else
        element.edit = false;
    });
    _incomShareBloc.add(_incomShareBloc.value);
  }

  newIncomeShare(int incid){
    if (_incomShareBloc.value.rows.length==0 || _incomShareBloc.value.rows[0].id > 0){
      _incomShareBloc.value.rows.insert(2, Incomeshare(incid: incid, id: 0, edit: true, name: '', perc: 0));
      _incomShareBloc.add(_incomShareBloc.value);
    }
  }


  loadIncomeHistory(BuildContext context, int incid) async{
    try{
      _incomBloc.value.rows.forEach((element) {
        if (element.id == incid)
          element.pricehistory = !element.pricehistory;
        element.share = false;
        element.company = false;
      });
      _incomBloc.add(_incomBloc.value);
      _incomHistoryBloc.add(IncomeHistoryModel(status: Status.loading));
      _incomHistoryBloc.add(IncomeHistoryModel(status: Status.loaded, rows: await _repo.loadHistory(readToken(context), incid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _incomHistoryBloc.add(IncomeHistoryModel(status: Status.error, msg: '$e'));
    }
  }

  saveIncomeHistory(BuildContext context, Incomehistory hst) async{
    if (hst.date.isEmpty)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'تاریخ مشخص نشده است');
    else if (hst.price == 0)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'قیمت مشخص نشده است');
    else
      try{
        showWaiting(context);
        hst.token = readToken(context);
        int _id = await _repo.saveHistory(hst);
        _incomHistoryBloc.value.rows.forEach((element) {
          if (element.id == hst.id){
            element.id = _id;
            element.edit = false;
          }
        });
        _incomHistoryBloc.add(_incomHistoryBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  delIncomeHistory(BuildContext context, Incomehistory hst){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${hst.date} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        hst.token = readToken(context);
        await _repo.deleteHistory(hst);
        _incomHistoryBloc.value.rows.removeWhere((element)=> element.id==hst.id);
        _incomHistoryBloc.add(_incomHistoryBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  editIncomeHistory(int id){
    _incomHistoryBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.edit = true;
      else
        element.edit = false;
    });
    _incomHistoryBloc.add(_incomHistoryBloc.value);
  }

  newIncomeHistory(int incid){
    if (_incomHistoryBloc.value.rows.length == 0 || _incomHistoryBloc.value.rows[0].id > 0){
      _incomHistoryBloc.value.rows.insert(0, Incomehistory(incid: incid, id: 0, edit: true, date: '', price: 0));
      _incomHistoryBloc.add(_incomHistoryBloc.value);
    }
  }


  loadIncomeCompany(BuildContext context, int incid) async{
    try{
      _incomBloc.value.rows.forEach((element) {
        if (element.id == incid)
          element.company = !element.company;
        element.share = false;
        element.pricehistory = false;
      });
      _incomBloc.add(_incomBloc.value);
      _incomCompanyBloc.add(IncomeCompanyModel(status: Status.loading));
      _incomCompanyBloc.add(IncomeCompanyModel(status: Status.loaded, rows: await _repo.loadCompany(readToken(context), incid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _incomCompanyBloc.add(IncomeCompanyModel(status: Status.error, msg: '$e'));
    }
  }

  saveIncomeCompany(BuildContext context, Incomecompany cmp) async{
    if (cmp.cmpid==0)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'اتحادیه مشخص نشده است');
    else
      try{
        showWaiting(context);
        cmp.token = readToken(context);
        await _repo.saveCompany(cmp);
        _incomCompanyBloc.value.rows.forEach((element) {
          if (element.cmpid == cmp.cmpid){
            element.old = cmp.cmpid;
            element.edit = false;
          }
        });
        _incomCompanyBloc.add(_incomCompanyBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  delIncomeCompany(BuildContext context, Incomecompany cmp){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${cmp.cmpname} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        cmp.token = readToken(context);
        await _repo.deleteCompany(cmp);
        _incomCompanyBloc.value.rows.removeWhere((element)=> element.cmpid==cmp.cmpid);
        _incomCompanyBloc.add(_incomCompanyBloc.value);
        hideWaiting(context);
        Navigator.pop(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
    });
  }

  editIncomeCompany(int cmpid){
    _incomCompanyBloc.value.rows.forEach((element) {
      if (element.cmpid == cmpid)
        element.edit = true;
      else
        element.edit = false;
    });
    _incomCompanyBloc.add(_incomCompanyBloc.value);
  }

  newIncomeCompany(int incid){
    if (_incomCompanyBloc.value.rows.length == 0 || _incomCompanyBloc.value.rows[0].cmpid > 0){
      _incomCompanyBloc.value.rows.insert(0, Incomecompany(incid: incid, old: 0, cmpid: 0, edit: true, allraste: true));
      _incomCompanyBloc.add(_incomCompanyBloc.value);
    }
  }

  changeAllRaste(BuildContext context, Incomecompany cmp){
    cmp.allraste = !cmp.allraste;
    saveIncomeCompany(context, cmp);
  }


  loadIncomeCompanyRaste(BuildContext context, int incid, int cmpid) async{
    try{
      _incomCompanyRasteBloc.add(IncomeCompanyRasteModel(status: Status.loading));
      _incomCompanyRasteBloc.add(IncomeCompanyRasteModel(status: Status.loaded, rows: await _repo.loadCompanyRaste(readToken(context), incid, cmpid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _incomCompanyRasteBloc.add(IncomeCompanyRasteModel(status: Status.error, msg: '$e'));
    }
  }

  saveIncomeCompanyRaste(BuildContext context, Incomecompanyraste rst) async{
    if (rst.hisic==0 && rst.isic==0)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'رسته مشخص نشده است');
    else
      try{
        showWaiting(context);
        rst.token = readToken(context);
        int _id = await _repo.saveCompanyRaste(rst);
        _incomCompanyRasteBloc.value.rows.forEach((element) {
          if (element.id == rst.id)
            element.id = _id;
            element.edit = false;
        });
        _incomCompanyRasteBloc.add(_incomCompanyRasteBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  newIncomeCompanyRaste(int incid, int cmpid){
    if (_incomCompanyRasteBloc.value.rows.length == 0 || _incomCompanyRasteBloc.value.rows[0].cmpid > 0){
      _incomCompanyRasteBloc.value.rows.insert(0, Incomecompanyraste(incid: incid, cmpid: cmpid, edit: true, id: 0, hisic: 0, isic: 0, name: '', grade1: false, grade2: false, grade3: false, grade4: false));
      _incomCompanyRasteBloc.add(_incomCompanyRasteBloc.value);
    }
  }

  editIncomeCompanyRaste(int id){
    _incomCompanyRasteBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.edit = true;
      else
        element.edit = false;
    });
    _incomCompanyRasteBloc.add(_incomCompanyRasteBloc.value);
  }

  changeRasteGrade(BuildContext context, Incomecompanyraste rst, {bool grade1=false, bool grade2=false, bool grade3=false, bool grade4=false}){
    if (grade1)
      rst.grade1 = !rst.grade1;
    if (grade2)
      rst.grade2 = !rst.grade2;
    if (grade3)
      rst.grade3 = !rst.grade3;
    if (grade4)
      rst.grade4 = !rst.grade4;
    saveIncomeCompanyRaste(context, rst);
  }
}