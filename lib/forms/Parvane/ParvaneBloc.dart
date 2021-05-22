import 'package:flutter/material.dart';
import 'package:pama/module/theme-Manager.dart';
import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';
import 'package:rxdart/subjects.dart';
import 'package:provider/provider.dart';

class ParvaneModel{
  Status status;
  List<Parvane> rows;
  String msg;

  ParvaneModel({@required this.status, this.rows, this.msg});
}
class ParvaneMobasherModel{
  Status status;
  List<ParvaneMobasher> rows;
  String msg;

  ParvaneMobasherModel({@required this.status, this.rows, this.msg});
}

class ParvaneBloc{
  ParvaneRepository _repository = ParvaneRepository();

  BehaviorSubject<ParvaneModel> _parvane = BehaviorSubject<ParvaneModel>()..add(ParvaneModel(status: Status.initial));
  Stream<ParvaneModel> get stream$ => _parvane.stream;
  ParvaneModel get value$ => _parvane.stream.value;

  BehaviorSubject<ParvaneMobasherModel> _parvaneMobasher = BehaviorSubject<ParvaneMobasherModel>()..add(ParvaneMobasherModel(status: Status.initial));
  Stream<ParvaneMobasherModel> get mobasherstream$ => _parvaneMobasher.stream;
  ParvaneMobasherModel get mobashervalue$ => _parvaneMobasher.stream.value;

  loadData(BuildContext context, User user, int accept) async{
    try{
      _parvane.add(ParvaneModel(status: Status.loading));
      _parvane.add(ParvaneModel(status: Status.loaded, rows: await _repository.loadData(Parvane(cmpid: user.cmpid, token: readToken(context), accept: accept))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _parvane.add(ParvaneModel(status: Status.error, msg: compileErrorMessage('$e')));
    }
  }

  saveData(BuildContext context, Parvane parvane) async{
    try{
      showWaiting(context);
      parvane.token = readToken(context);
      parvane.cmpid = context.read<ThemeManager>().cmpid;
      
      int _id = await _repository.saveData(parvane);
      if (parvane.id == 0){
        parvane.id = _id;
        _parvane.value.rows.insert(0, parvane);
      }
      else
        _parvane.add(_parvane.value);
    }
    catch(e){
      analyzeError(context, '$e', msg: true);
    }
    finally{
      hideWaiting(context);
    }
  }

  loadMobasher(BuildContext context, int parvaneid) async{
    try{
      _parvaneMobasher.add(ParvaneMobasherModel(status: Status.loading));
      _parvaneMobasher.add(ParvaneMobasherModel(status: Status.loaded, rows: await _repository.loadMObasher(ParvaneMobasher(parvaneid: parvaneid, token: readToken(context)))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _parvaneMobasher.add(ParvaneMobasherModel(status: Status.error, msg: compileErrorMessage('$e')));
    }
  }
  addMobasher(BuildContext context, int parvane, People peop) async{
    try{
      int _id = await _repository.addMobasher(ParvaneMobasher(id: 0, peopid: peop.id, parvaneid: parvane, token: readToken(context)));
      _parvaneMobasher.value.rows.insert(0, ParvaneMobasher(id: _id, parvaneid: parvane, peopid: peop.id, nationalid: peop.nationalid, name: peop.name, family: peop.family, father: peop.father, ss: peop.ss));
      _parvaneMobasher.add(_parvaneMobasher.value);
    }
    catch(e){
      analyzeError(context, '$e', msg: true);
    }
  }
  delMobasher(BuildContext context, ParvaneMobasher mobasher) async{
    confirmMessage(context, 'حذف مباشر', 'آیا مایل به حذف ${mobasher.name} ${mobasher.family} می باشید؟', yesclick: () async{
      try{
        mobasher.token = readToken(context);
        await _repository.delMobasher(mobasher);
        _parvaneMobasher.value.rows.removeWhere((element) => element.id==mobasher.id);
        _parvaneMobasher.add(_parvaneMobasher.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e', msg: true);
      }
    });
  }
}