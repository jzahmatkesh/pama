import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/rxdart.dart';

class GUnitModel{
  Status status;
  List<GUnit> rows;
  String msg;

  GUnitModel({this.status, this.rows, this.msg});
}

class PeopleBloc{
  GUnitRepository _repository = GUnitRepository();

  BehaviorSubject<GUnitModel> _peoplebloc = BehaviorSubject<GUnitModel>.seeded(GUnitModel(status: Status.initial));

  Stream<GUnitModel> get peopleStream$ => _peoplebloc.stream;
  List<GUnit> get peopleInfo$ => _peoplebloc.stream.value.rows;

  backtogetNationalID(){
    _peoplebloc.add(GUnitModel(status: Status.initial));
  }

  checkNosaziCode(BuildContext context, Map<String, dynamic> data, bool justcheck, {int cmpid=0}) async{
  }
}
