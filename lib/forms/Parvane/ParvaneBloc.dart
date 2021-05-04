import 'package:flutter/material.dart';
import 'package:pama/classes/Repository.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/module/functions.dart';
import 'package:rxdart/subjects.dart';

class ParvaneModel{
  Status status;
  List<Parvane> rows;
  String msg;

  ParvaneModel({@required this.status, this.rows, this.msg});
}

class ParvaneBloc{
  ParvaneRepository _repository = ParvaneRepository();

  BehaviorSubject<ParvaneModel> _parvane = BehaviorSubject<ParvaneModel>()..add(ParvaneModel(status: Status.initial));
  Stream<ParvaneModel> get stream$ => _parvane.stream;
  ParvaneModel get value$ => _parvane.stream.value;

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
}