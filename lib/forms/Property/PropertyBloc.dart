import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/subjects.dart';

class PropertyModel{
  Status status;
  List<Property> rows;
  String msg;

  PropertyModel({@required this.status, this.rows, this.msg});
}

class PropertyBloc{
  PropertyRepository _repository = PropertyRepository();

  BehaviorSubject<int> _menuBloc = BehaviorSubject<int>.seeded(1);
  Stream<int> get menuStream$ => _menuBloc.stream;

  BehaviorSubject<int> _accountBloc = BehaviorSubject<int>.seeded(1);
  Stream<int> get accountTypeStream$ => _accountBloc.stream;
  BehaviorSubject<int> _malekiatBloc = BehaviorSubject<int>.seeded(1);
  Stream<int> get malekiaTypeStream$ => _malekiatBloc.stream;
  BehaviorSubject<int> _tenantBloc = BehaviorSubject<int>.seeded(1);
  Stream<int> get tenantTypeStream$ => _tenantBloc.stream;

  BehaviorSubject<PropertyModel> _propertyBloc = BehaviorSubject<PropertyModel>.seeded(PropertyModel(status: Status.loading));
  Stream<PropertyModel> get propertyStream$ => _propertyBloc.stream;

  setMultItem(int val, {bool tenant=false, bool account=false, bool malekiat=false}){
    if (tenant)
      _tenantBloc.add(val);
    if (malekiat)
      _malekiatBloc.add(val);
    if (account)
      _accountBloc.add(val);
  }

  loadMobile(BuildContext context, int cmpid) async{
    try{
      _menuBloc.add(1);
      _propertyBloc.add(PropertyModel(status: Status.loading));
      _propertyBloc.add(PropertyModel(status: Status.loaded, rows: await _repository.loadMobile(readToken(context), cmpid)));
    } 
    catch(e){
      analyzeError(context, '$e');
      _propertyBloc.add(PropertyModel(status: Status.error, msg: '$e'));
    }   
  }
  saveMobile(BuildContext context, Property prop) async{
    if ((prop.peopid ?? 0) == 0)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'تحویل گیرنده مشخص نشده است');
    else
    try{
      showWaiting(context);
      prop.token = readToken(context);
      int _id =  await _repository.saveMobile(prop);
      prop.id = _id;
      bool nv = true;
      _propertyBloc.value.rows.forEach((element) {if (element.id == prop.id){nv=false;element.id = _id;}});
      if (nv)
        _propertyBloc.value.rows.insert(0, prop);
      _propertyBloc.add(_propertyBloc.value);
      Navigator.pop(context);
      hideWaiting(context);      
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }
  delMobile(BuildContext context, Property prop){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف موبایل ${prop.name} می باشید؟', yesclick: () async {
      try{
        prop.token = readToken(context);
        await _repository.delMobile(readToken(context), prop);
        _propertyBloc.value.rows.removeWhere((element) => element.id == prop.id);
        _propertyBloc.add(_propertyBloc.value);
        Navigator.pop(context);
      } 
      catch(e){
        analyzeError(context, '$e');
      }   
    });
  }
  setActive(BuildContext context, int id) async{
    try{
      int _act = await _repository.setActive(Property(token: readToken(context), id: id));
      _propertyBloc.value.rows.forEach((element) {
        if (element.id == id)
          element.active = _act;
      });
      _propertyBloc.add(_propertyBloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }
  
  setInternetBank(BuildContext context, int id) async{
    try{
      int _int = await _repository.setInternetBank(Property(token: readToken(context), id: id));
      _propertyBloc.value.rows.forEach((element) {
        if (element.id == id)
          element.internetbank = _int;
      });
      _propertyBloc.add(_propertyBloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }

  loadCar(BuildContext context, int cmpid) async{
    try{
      _menuBloc.add(2);
      _propertyBloc.add(PropertyModel(status: Status.loading));
      _propertyBloc.add(PropertyModel(status: Status.loaded, rows: await _repository.loadCar(readToken(context), cmpid)));
    } 
    catch(e){
      analyzeError(context, '$e');
      _propertyBloc.add(PropertyModel(status: Status.error, msg: '$e'));
    }   
  }
  saveCar(BuildContext context, Property prop) async{
    if ((prop.peopid ?? 0) == 0)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'تحویل گیرنده مشخص نشده است');
    else
    try{
      showWaiting(context);
      prop.token = readToken(context);
      int _id =  await _repository.saveCar(prop);
      prop.id = _id;
      bool nv = true;
      _propertyBloc.value.rows.forEach((element) {if (element.id == prop.id){nv=false;element.id = _id;}});
      if (nv)
        _propertyBloc.value.rows.insert(0, prop);
      _propertyBloc.add(_propertyBloc.value);
      Navigator.pop(context);
      hideWaiting(context);      
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }
  delCar(BuildContext context, Property prop){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف خودرو ${prop.name} می باشید؟', yesclick: () async {
      try{
        prop.token = readToken(context);
        await _repository.delCar(readToken(context), prop);
        _propertyBloc.value.rows.removeWhere((element) => element.id == prop.id);
        _propertyBloc.add(_propertyBloc.value);
        Navigator.pop(context);
      } 
      catch(e){
        analyzeError(context, '$e');
      }   
    });
  }

  loadPropGHM(BuildContext context, int cmpid) async{
    try{
      _menuBloc.add(3);
      _propertyBloc.add(PropertyModel(status: Status.loading));
      _propertyBloc.add(PropertyModel(status: Status.loaded, rows: await _repository.loadPropGHM(readToken(context), cmpid)));
    } 
    catch(e){
      analyzeError(context, '$e');
      _propertyBloc.add(PropertyModel(status: Status.error, msg: '$e'));
    }   
  }
  savePropGHM(BuildContext context, Property prop) async{
    try{
      showWaiting(context);
      prop.token = readToken(context);
      int _id =  await _repository.savePropGHM(prop);
      prop.id = _id;
      bool nv = true;
      _propertyBloc.value.rows.forEach((element) {if (element.id == prop.id){nv=false;element.id = _id;}});
      if (nv)
        _propertyBloc.value.rows.insert(0, prop);
      _propertyBloc.add(_propertyBloc.value);
      Navigator.pop(context);
      hideWaiting(context);      
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }
  delPropGHM(BuildContext context, Property prop){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${prop.name} می باشید؟', yesclick: () async {
      try{
        prop.token = readToken(context);
        await _repository.delPropGHM(readToken(context), prop);
        _propertyBloc.value.rows.removeWhere((element) => element.id == prop.id);
        _propertyBloc.add(_propertyBloc.value);
        Navigator.pop(context);
      } 
      catch(e){
        analyzeError(context, '$e');
      }   
    });
  }

  loadBankHesab(BuildContext context, int cmpid) async{
    try{
      _menuBloc.add(4);
      _propertyBloc.add(PropertyModel(status: Status.loading));
      _propertyBloc.add(PropertyModel(status: Status.loaded, rows: await _repository.loadBankHesab(readToken(context), cmpid)));
    } 
    catch(e){
      analyzeError(context, '$e');
      _propertyBloc.add(PropertyModel(status: Status.error, msg: '$e'));
    }   
  }
  saveBankHesab(BuildContext context, Property prop) async{
    try{
      showWaiting(context);
      prop.token = readToken(context);
      int _id =  await _repository.saveBankHesab(prop);
      prop.id = _id;
      bool nv = true;
      _propertyBloc.value.rows.forEach((element) {if (element.id == prop.id){nv=false;element.id = _id;}});
      if (nv)
        _propertyBloc.value.rows.insert(0, prop);
      _propertyBloc.add(_propertyBloc.value);
      Navigator.pop(context);
      hideWaiting(context);      
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }
  delBankHesab(BuildContext context, Property prop){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${prop.accountTypeName()} ${prop.hesabno} ${prop.bankName} می باشید؟', yesclick: () async {
      try{
        prop.token = readToken(context);
        await _repository.delBankHesab(readToken(context), prop);
        _propertyBloc.value.rows.removeWhere((element) => element.id == prop.id);
        _propertyBloc.add(_propertyBloc.value);
        Navigator.pop(context);
      } 
      catch(e){
        analyzeError(context, '$e');
      }   
    });
  }
}