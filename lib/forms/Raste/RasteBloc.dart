import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class RasteModel{
  Status status;
  List<Raste> rows;
  String msg;

  RasteModel({this.status, this.rows, this.msg});
}
class DRasteModel{
  Status status;
  List<DRaste> rows;
  String msg;

  DRasteModel({this.status, this.rows, this.msg});
}

class RasteBloc{
  RasteRepository _repository = new RasteRepository();

  BehaviorSubject<RasteModel> _rasteBloc = BehaviorSubject<RasteModel>.seeded(RasteModel(status: Status.loading));
  Stream<RasteModel> get rasteblocStream$ => _rasteBloc.stream;

  BehaviorSubject<Raste> _newrasteBloc = BehaviorSubject<Raste>();
  Stream<Raste> get newrasteStream$ => _newrasteBloc.stream;

  BehaviorSubject<DRasteModel> _drasteBloc = BehaviorSubject<DRasteModel>.seeded(DRasteModel(status: Status.loading));
  Stream<DRasteModel> get drasteblocStream$ => _drasteBloc.stream;
  BehaviorSubject<DRaste> _newdrasteBloc = BehaviorSubject<DRaste>();
  Stream<DRaste> get newdrasteblocStream$ => _newdrasteBloc.stream;

  loadData(BuildContext context) async{
    try{
      _rasteBloc.add(RasteModel(status: Status.loading));
      _rasteBloc.add(RasteModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _rasteBloc.add(RasteModel(status: Status.error, msg: '$e'));
    }
  }
  
  loadRasteDRaste(BuildContext context) async{
    try{
      _rasteBloc.add(RasteModel(status: Status.loading));
      _rasteBloc.add(RasteModel(status: Status.loaded, rows: await _repository.loadRasteDRaste(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _rasteBloc.add(RasteModel(status: Status.error, msg: '$e'));
    }
  }
  searchRaste(String val){
    _rasteBloc.value.rows.forEach((element){
      element.searched = element.isic.toString().contains(val) || element.name.contains(val) || element.cmpname.contains(val) || element.draste.contains(val);
    });
    _rasteBloc.add(_rasteBloc.value);
  }
  setActive(BuildContext context, bool val, int isic){
    _rasteBloc.value.rows.forEach((element) async {
      if (element.isic == isic){
        element.token = readToken(context);
        try{
          element.active = await _repository.setActive(element);
        }
        catch(e){
          analyzeError(context, '$e');
        }
      }
      _rasteBloc.add(_rasteBloc.value);
    });
  }
  delraste(BuildContext context, Raste raste){
    confirmMessage(context, 'حذف رسته', 'آیا مایل به حذف رسته ${raste.name} می باشید؟', yesclick: () async{
      try{
        raste.token = readToken(context);
        await _repository.delRaste(raste);
        _rasteBloc.value.rows.removeWhere((element) => element.isic == raste.isic);
        _rasteBloc.add(_rasteBloc.value);
      }
      catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }

  newraste(Raste raste){
    _newrasteBloc.add(raste);
  }
  setRasteKind(int val){
    _newrasteBloc.value.kind = val;
    _newrasteBloc.add(_newrasteBloc.value);
  }
  setRastePriceKind(int val){
    _newrasteBloc.value.pricekind = val;
    _newrasteBloc.add(_newrasteBloc.value);
  }
  saveRaste(BuildContext context, Raste raste) async{
    showWaiting(context);
    try{
      raste.token = readToken(context);
      await _repository.save(raste);
      bool nw = true;
      _rasteBloc.value.rows.forEach((element) {
        if (element.old == raste.old){
          nw = false;
          element = raste;
          element.old = element.isic;
        }
      });
      if (nw)
        _rasteBloc.value.rows.insert(0, raste);
      _rasteBloc.add(_rasteBloc.value);
      hideWaiting(context);
      Navigator.pop(context);
      myAlert(context: context, title: 'موفقیت آمیز', message: 'ذخیره اطلاعات موفقیت آمیز بود', color: Colors.green);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    } 
  }

  hideDRaste(int isic){
    _rasteBloc.value.rows.forEach((element) {
      element.showdraste = false;
    });
    _rasteBloc.add(_rasteBloc.value);
  }
  showDRaste(BuildContext context, int isic){
    _rasteBloc.value.rows.forEach((element) {
      if (element.isic == isic){
        element.showdraste = !element.showdraste;
        loadDRaste(context, isic);
      }
      else
        element.showdraste = false;
    });
    _rasteBloc.add(_rasteBloc.value);
  }
  loadDRaste(BuildContext context, int hisic) async{
    try{
      _drasteBloc.add(DRasteModel(status: Status.loading));
      _drasteBloc.add(DRasteModel(status: Status.loaded, rows: await _repository.loadDRaste(readToken(context), hisic)));
    }
    catch(e){
      analyzeError(context, e.toString(), msg: false);
      _drasteBloc.add(DRasteModel(status: Status.error, msg: '$e'));
    }
  }
  setDRasteActive(BuildContext context, int isic, bool act){
    _drasteBloc.value.rows.forEach((element) async {
      if (element.isic == isic){
        element.token = readToken(context);
        try{
          element.active = await _repository.setDrasteActive(element);
        }
        catch(e){
          analyzeError(context, '$e');
        }
      }
      _drasteBloc.add(_drasteBloc.value);
    });
  }
  newdraste(DRaste draste){
    _newdrasteBloc.add(draste);
  }
  saveDRaste(BuildContext context, DRaste draste) async{
    showWaiting(context);
    try{
      draste.token = readToken(context);
      await _repository.saveDRaste(draste);
      bool nw = true;
      _drasteBloc.value.rows.forEach((element) {
        if (element.old == draste.old){
          nw = false;
          element = draste;
          element.old = element.isic;
        }
      });
      if (nw){
        draste.old = draste.isic;
        _drasteBloc.value.rows.insert(0, draste);
      }
      _drasteBloc.add(_drasteBloc.value);
      hideWaiting(context);
      Navigator.pop(context);
      myAlert(context: context, title: 'موفقیت آمیز', message: 'ذخیره اطلاعات موفقیت آمیز بود', color: Colors.green);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    } 
  }
  delDraste(BuildContext context, DRaste draste){
    confirmMessage(context, 'حذف زیر رسته', 'آیا مایل به حذف زیر رسته ${draste.name} می باشید؟', yesclick: () async{
      try{
        draste.token = readToken(context);
        await _repository.delDRaste(draste);
        _drasteBloc.value.rows.removeWhere((element) => element.isic == draste.isic);
        _drasteBloc.add(_drasteBloc.value);
      }
      catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
}