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
class ParvaneProcessModel{
  Status status;
  List<ParvaneProcess> rows;
  String msg;

  ParvaneProcessModel({@required this.status, this.rows, this.msg});
}
class PPDocumentModel{
  Status status;
  List<ParvaneProcessDocument> rows;
  String msg;

  PPDocumentModel({@required this.status, this.rows, this.msg});
}

class PPrcBloc{
  ParvaneRepository _repository = ParvaneRepository();
    
  BehaviorSubject<PPrcModel> _bloc = BehaviorSubject<PPrcModel>.seeded(PPrcModel(status: Status.loading));
  Stream<PPrcModel> get stream => _bloc.stream;
  PPrcModel get value => _bloc.value;
    
  BehaviorSubject<PPDocumentModel> _ppDocumentbloc = BehaviorSubject<PPDocumentModel>.seeded(PPDocumentModel(status: Status.loading));
  Stream<PPDocumentModel> get ppDocumentstream => _ppDocumentbloc.stream;
  PPDocumentModel get ppDocumentvalue => _ppDocumentbloc.value;
    
  BehaviorSubject<ParvaneProcessModel> _pprocessbloc = BehaviorSubject<ParvaneProcessModel>.seeded(ParvaneProcessModel(status: Status.loading));
  Stream<ParvaneProcessModel> get pprocessstream => _pprocessbloc.stream;
  ParvaneProcessModel get pprocessvalue => _pprocessbloc.value;

  loadProcess({@required BuildContext context, @required int parvaneID}) async{
    try{
      _bloc.add(PPrcModel(status: Status.loading));
      _bloc.add(PPrcModel(status: Status.loaded, rows: await _repository.loadParvaneNewProcess(Parvane(token: readToken(context), cmpid: readCmpid(context), id: parvaneID))));
    }
    catch(e){
      _bloc.add(PPrcModel(status: Status.error, msg: '$e'));
    }
  }

  Future<bool> newprocess(BuildContext context, int parvaneID, int processid) async{
    try{
      showWaiting(context);
      await _repository.addProcessToParvane(ParvaneProcess(token: readToken(context), processid: processid, parvaneid: parvaneID));
      return true;
    }
    catch(e){
      myAlert(context: context, title: 'خطا', message: '$e');
    }
    finally{
      hideWaiting(context);
    }
    return false;
 }

  loadParvaneProcess({@required BuildContext context, @required int parvaneID, int idstep = 0}) async{
    try{
      _pprocessbloc.add(ParvaneProcessModel(status: Status.loading));
      var _rows = await _repository.loadParvaneProcess(Parvane(token: readToken(context), id: parvaneID));
      if (idstep > 0)
        _rows.where((element) => element.id==idstep).first.showSteps = true;
      _pprocessbloc.add(ParvaneProcessModel(status: Status.loaded, rows: _rows));
    }
    catch(e){
      _pprocessbloc.add(ParvaneProcessModel(status: Status.error, msg: '$e'));
    }
  }

  showParvaneProcessSteps(BuildContext context, int id) async{
    try{
      showWaiting(context);
      pprocessvalue.rows.forEach((element)=>element.showSteps=element.id==id && !element.showSteps);
      _pprocessbloc.add(pprocessvalue);
    }
    catch(e){
      _pprocessbloc.add(ParvaneProcessModel(status: Status.error, msg: '$e'));
    }
    finally{
      hideWaiting(context);
    }
  }

  showPPStepDocument(BuildContext context, int ppid, int stepid) async{
    try{
      _ppDocumentbloc.add(PPDocumentModel(status: Status.loading));
      _ppDocumentbloc.add(PPDocumentModel(status: Status.loaded, rows: await _repository.loadParvaneProcessDocument(ppid, stepid)));
    }
    catch(e){
      _ppDocumentbloc.add(PPDocumentModel(status: Status.error, msg: '$e'));
    }
  }

  refreshDocument()=>_ppDocumentbloc.add(_ppDocumentbloc.value);
}