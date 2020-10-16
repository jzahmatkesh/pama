import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  checkNationalID(BuildContext context, Map<String, dynamic> data) async{
    try {
      _peoplebloc.add(PeopleModel(status: Status.loading));
      _peoplebloc.add(PeopleModel(status: Status.loaded, rows: await _repository.checkNationalID(readToken(context), data['nationalid'], data['family'], data['mobile'])));
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
      _peoplebloc.add(PeopleModel(status: Status.success, rows: _peoplebloc.value.rows, msg: ""));
      // Navigator.pop(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, e.toString());
   }
  }
}