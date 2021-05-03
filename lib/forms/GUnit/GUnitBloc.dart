import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/rxdart.dart';

class GUnitModel{
  Status status;
  GUnit gunit;
  String msg;

  GUnitModel({this.status, this.gunit, this.msg});
}

class GUnitBloc{
  GUnitRepository _repository = GUnitRepository();

  BehaviorSubject<GUnitModel> _gunitbloc = BehaviorSubject<GUnitModel>.seeded(GUnitModel(status: Status.initial));

  Stream<GUnitModel> get peopleStream$ => _gunitbloc.stream;
  GUnit get peopleInfo$ => _gunitbloc.stream.value.gunit;

  backtogetNationalID(){
    _gunitbloc.add(GUnitModel(status: Status.initial));
  }

  checkNosaziCode(BuildContext context, String code, bool justcheck) async{
    try{
      _gunitbloc.add(GUnitModel(status: Status.loading));
      _gunitbloc.add(GUnitModel(gunit: await _repository.findByNosaziCode(readToken(context), code), status: Status.loaded));
      if (justcheck)
        Navigator.of(context).pop(_gunitbloc.value.gunit);
    }
    catch(e){
      if (justcheck)
        Navigator.of(context).pop('${compileErrorMessage('$e')}');
      else
        _gunitbloc.add(GUnitModel(status: Status.error, msg: compileErrorMessage('$e')));
    }    
  }
}
