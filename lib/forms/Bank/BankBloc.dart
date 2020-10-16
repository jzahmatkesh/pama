import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class BankModel{
  Status status;
  List<Bank> rows;
  String msg;

  BankModel({this.status, this.rows, this.msg});
}

class BankBloc{
  BankRepository _repository = new BankRepository();
  
  BehaviorSubject<BankModel> _bankbloc = BehaviorSubject<BankModel>.seeded(BankModel(status: Status.loading));
  Stream<BankModel> get bankStream$ => _bankbloc.stream;

  loadData(BuildContext context) async{
    try{
      _bankbloc.add(BankModel(status: Status.loading));
      _bankbloc.add(BankModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _bankbloc.add(BankModel(status: Status.error, msg: '$e'));
    }
  }

  saveBank(BuildContext context, Bank bank) async{
    if (bank.name.trim().isEmpty) 
      myAlert(context: context, title: "خطا", message: "عنوان بانک مشخص نشده است");
    else
      try{
        showWaiting(context);
        bank.token = readToken(context);
        int id = await _repository.save(bank);
        bool nw = true;
        _bankbloc.value.rows.forEach((element) {
          if (element.id == id){
            element.editing = false;
            nw = false;
          }
        });
        if (nw)
          _bankbloc.value.rows.forEach((element) {
            if (element.id == 0){
              element.editing = false;
              element.id = id;
              element.name = bank.name;
              nw = false;
            }
          });
        _bankbloc.add(_bankbloc.value);
        myAlert(context: context, title: "ذخیره", message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.green);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  newBank(BuildContext context){
    _bankbloc.value.rows.insert(0, new Bank(id: 0, name: ""));
    _bankbloc.add(_bankbloc.value);
  }

  delBank(BuildContext context, Bank bank){
    confirmMessage(context, 'تایید حذف', "آیا مایل به حذف ${bank.name} می باشید؟", yesclick: () async{
      try{
        showWaiting(context);
        bank.token = readToken(context);
        await _repository.delete(bank);
        _bankbloc.value.rows.removeWhere((element) => element.id == bank.id);
        _bankbloc.add(_bankbloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  editMode(Bank bank){
    _bankbloc.value.rows.forEach((element) {
      element.editing = element.id == bank.id;
    });
    _bankbloc.add(_bankbloc.value);
  }
}