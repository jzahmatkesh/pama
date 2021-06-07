import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class PPrcModel{
  Status status;
  List<Process> rows;
  String msg;

  PPrcModel({@required this.status, this.rows, this.msg});
}

class PPrcBloc{
  ParvaneRepository _repository = ParvaneRepository();
    
  BehaviorSubject<PPrcModel> _bloc = BehaviorSubject<PPrcModel>.seeded(PPrcModel(status: Status.loading));
  Stream<PPrcModel> get stream => _bloc.stream;
  PPrcModel get value => _bloc.value;

  loadProcess({@required BuildContext context, @required int parvaneID}) async{
    try{
      _bloc.add(PPrcModel(status: Status.loading));
      _bloc.add(PPrcModel(status: Status.loaded, rows: await _repository.loadParvaneNewProcess(Parvane(token: readToken(context), cmpid: readCmpid(context), id: parvaneID))));
    }
    catch(e){
      _bloc.add(PPrcModel(status: Status.error, msg: '$e'));
    }
  }

  newprocess(BuildContext context, int parvaneID, int processid) async{
    try{
      showWaiting(context);
      await _repository.addProcessToParvane(ParvaneProcess(token: readToken(context), processid: processid, parvaneid: parvaneID));
    }
    catch(e){
      myAlert(context: context, title: 'خطا', message: '$e');
    }
    finally{
      hideWaiting(context);
    }
 }
}