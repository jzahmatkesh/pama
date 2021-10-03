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
      GUnit gun = await _repository.findByNosaziCode(readToken(context), code);
      if (gun == null)
      _gunitbloc.add(GUnitModel(gunit: gun, status: Status.loaded));
      if (justcheck)
        Navigator.of(context).pop(gun);
    }
    catch(e){
      myAlert(context: context, title: 'خطا', message: '$e');
      // if (!justcheck)
      _gunitbloc.add(GUnitModel(gunit: GUnit(id: 0, nosazicode: code), status: Status.loaded));
      // else
      // Navigator.of(context).pop('${compileErrorMessage('$e')}');
    }    
  }

  saveGUnit(BuildContext context) async{
    try{
      _gunitbloc.value.gunit.token = readToken(context);
      int _id = await _repository.save(_gunitbloc.value.gunit);
      _gunitbloc.value.gunit.id = _id;
      _gunitbloc.add(_gunitbloc.value);
      Navigator.of(context).pop(_gunitbloc.value.gunit);
      myAlert(context: context, title: 'ذخیره', message: 'با موفقیت انجام گردید', color: Colors.green);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }
}
