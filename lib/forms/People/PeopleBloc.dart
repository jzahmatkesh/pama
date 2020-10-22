import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/module/Widgets.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class PeopleModel{
  Status status;
  List<People> rows;
  String msg;

  PeopleModel({this.status, this.rows, this.msg});
}

class PeopleBloc{
  PeopleRepository _repository = PeopleRepository();

  BehaviorSubject<PeopleModel> _peoplebloc = BehaviorSubject<PeopleModel>.seeded(PeopleModel(status: Status.initial));

  Stream<PeopleModel> get peopleStream$ => _peoplebloc.stream;
  List<People> get peopleInfo$ => _peoplebloc.stream.value.rows;

  backtogetNationalID(){
    _peoplebloc.add(PeopleModel(status: Status.initial));
  }

  checkNationalID(BuildContext context, Map<String, dynamic> data, bool justcheck, {int cmpid=0}) async{
    if (data['nationalid'].toString().trim().isEmpty && data['family'].toString().trim().isEmpty && data['mobile'].toString().trim().isEmpty)
      myAlert(context: context, title: 'هشدارر', message: 'یکی از مقادیر جهت جستجو می بایست مشخص شود');
    else
    try {
      _peoplebloc.add(PeopleModel(status: Status.loading));
      final _rows = await _repository.checkNationalID(readToken(context), data['nationalid'], data['family'], data['mobile']);
      if (_rows.length == 0){
        myAlert(
          context: context, 
          title: 'هشدار', 
          message: Row(
            children: [
              Text('شخصی با اطلاعات فوق ثبت نشده است'), 
              SizedBox(width: 10.0), 
              MyOutlineButton(title: 'تعریف بعنوان شخص جدید', onPressed: ()=> _peoplebloc.add(PeopleModel(status: Status.loaded, rows: [People(id: 0, family: data['family'], nationalid: data['nationalid'], mobile: data['mobile'], bimeno: 0, single: 1, sex: 1, education: 1, isargari: 0, military: 1)])), icon: CupertinoIcons.person_badge_plus, color: Colors.white,)
            ]
          )
        );
        _peoplebloc.add(PeopleModel(status: Status.initial, msg: 'show_new'));
      }
      else if (_rows.length == 1 && justcheck)
        Navigator.of(context).pop(_rows[0]);
      else
        _peoplebloc.add(PeopleModel(status: Status.loaded, rows: _rows));
    } catch (e) {
      analyzeError(context, e.toString());
      _peoplebloc.add(PeopleModel(status: Status.error, msg: '$e'));
    }
  }
  
  setSingle(int val){
    _peoplebloc.value.rows[0].single = val;
    _peoplebloc.add(PeopleModel(status: Status.loaded, rows: _peoplebloc.value.rows));
  }
  setSex(int val){
    _peoplebloc.value.rows[0].sex = val;
    _peoplebloc.add(PeopleModel(status: Status.loaded, rows: _peoplebloc.value.rows));
  }
  setMilitary(int val){
    _peoplebloc.value.rows[0].military = val;
    _peoplebloc.add(PeopleModel(status: Status.loaded, rows: _peoplebloc.value.rows));
  }
  setEducation(int val){
    _peoplebloc.value.rows[0].education = val;
    _peoplebloc.add(PeopleModel(status: Status.loaded, rows: _peoplebloc.value.rows));
  }
  setIsargari(int val){
    _peoplebloc.value.rows[0].isargari = val;
    _peoplebloc.add(PeopleModel(status: Status.loaded, rows: _peoplebloc.value.rows));
  }

  savePeople(BuildContext context, People people) async{
    try{
      showWaiting(context);
      people.token = readToken(context);     
      await _repository.savePeople(people);
      hideWaiting(context);
      Navigator.of(context).pop(people);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, e.toString());
   }
  }
}