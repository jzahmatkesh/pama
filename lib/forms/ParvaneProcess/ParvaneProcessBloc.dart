import 'dart:convert';

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
class PPIncomeModel{
  Status status;
  List<ParvaneProcessIncome> rows;
  String msg;

  PPIncomeModel({@required this.status, this.rows, this.msg});
}
class PPMeetingModel{
  Status status;
  List<ParvaneProcessMeeting> rows;
  String msg;

  PPMeetingModel({@required this.status, this.rows, this.msg});
}
class PPInspectionModel{
  Status status;
  List<ParvaneProcessInspection> rows;
  String msg;

  PPInspectionModel({@required this.status, this.rows, this.msg});
}


class PPrcBloc{
  ParvaneProcessRepository _repository = ParvaneProcessRepository();
    
  BehaviorSubject<PPrcModel> _bloc = BehaviorSubject<PPrcModel>.seeded(PPrcModel(status: Status.loading));
  Stream<PPrcModel> get stream => _bloc.stream;
  PPrcModel get value => _bloc.value;
    
  BehaviorSubject<PPDocumentModel> _ppDocumentbloc = BehaviorSubject<PPDocumentModel>.seeded(PPDocumentModel(status: Status.loading));
  Stream<PPDocumentModel> get ppDocumentstream => _ppDocumentbloc.stream;
  PPDocumentModel get ppDocumentvalue => _ppDocumentbloc.value;
    
  BehaviorSubject<PPIncomeModel> _ppIncomebloc = BehaviorSubject<PPIncomeModel>.seeded(PPIncomeModel(status: Status.loading));
  Stream<PPIncomeModel> get ppIncomestream => _ppIncomebloc.stream;
  PPIncomeModel get ppIncomevalue => _ppIncomebloc.value;
    
  BehaviorSubject<PPMeetingModel> _ppMeetingbloc = BehaviorSubject<PPMeetingModel>.seeded(PPMeetingModel(status: Status.loading));
  Stream<PPMeetingModel> get ppMeetingstream => _ppMeetingbloc.stream;
  PPMeetingModel get ppMeetingvalue => _ppMeetingbloc.value;
    
  BehaviorSubject<PPInspectionModel> _ppInspectionbloc = BehaviorSubject<PPInspectionModel>.seeded(PPInspectionModel(status: Status.loading));
  Stream<PPInspectionModel> get ppInspectionstream => _ppInspectionbloc.stream;
  PPInspectionModel get ppInspectionvalue => _ppInspectionbloc.value;
    
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

  delParvaneProcess({@required BuildContext context, @required int id}){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف فرآیند می باشید؟', yesclick: () async{
      try{
        if (await _repository.delParvaneProcess(readToken(context), id)){
          _pprocessbloc.value.rows.removeWhere((element) => element.id==id);
          _pprocessbloc.add(_pprocessbloc.value);
        }
      }
      catch(e){
        myAlert(context: context, title: 'خطا', message: '$e');
      }
    });
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
  
  finishParvaneProcessStep(BuildContext context, int processid, Prcstep step) async{
    try{
      showWaiting(context);
      step.token = readToken(context);
      step.processid = processid;
print("${step.toJson()}");
      bool _res = await _repository.finishParavneProcessStep(step);
      String _steps = _pprocessbloc.value.rows.where((element) => element.id==step.processid).first.steps;
print("before: $_steps");
      _steps = (json.decode(_steps) as List).map((e){if (e['id'] == step.id) e['finish'] = _res ? 1 : 0;}).toString();
print("after: $_steps");
      _pprocessbloc.add(_pprocessbloc.value);
    }
    catch(e){
      myAlert(context: context, title: 'خطا', message: '$e');
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

  showPPStepIncome(BuildContext context, int ppid, int stepid) async{
    try{
      _ppIncomebloc.add(PPIncomeModel(status: Status.loading));
      _ppIncomebloc.add(PPIncomeModel(status: Status.loaded, rows: await _repository.loadParvaneProcessIncome(ppid, stepid)));
    }
    catch(e){
      _ppIncomebloc.add(PPIncomeModel(status: Status.error, msg: '$e'));
    }
  }
  editPPStepIncome(ParvaneProcessIncome data){
    _ppIncomebloc.value.rows.forEach((element)=>element.edit = element.incomeid == data.incomeid && !data.edit);
    _ppIncomebloc.add(_ppIncomebloc.value);
  }
  savePPStepIncome(BuildContext context, ParvaneProcessIncome data) async{
    try{
      showWaiting(context);
      data.token = readToken(context);
      await _repository.saveParvaneProcessIncome(data);
      data.edit = false;
      _ppIncomebloc.add(_ppIncomebloc.value); 
    }
    catch(e){
      myAlert(context: context, title: 'خطا', message: '$e');
    }
    finally{
      hideWaiting(context);
    }
  }

  showPPStepMeeting(BuildContext context, int ppid, int stepid) async{
    try{
      _ppMeetingbloc.add(PPMeetingModel(status: Status.loading));
      _ppMeetingbloc.add(PPMeetingModel(status: Status.loaded, rows: await _repository.loadParvaneProcessMeeting(ppid, stepid)));
    }
    catch(e){
      _ppMeetingbloc.add(PPMeetingModel(status: Status.error, msg: '$e'));
    }
  }
  editPPStepMeeting(ParvaneProcessMeeting data){
    _ppMeetingbloc.value.rows.forEach((element)=>element.edit = element.id == data.id && !data.edit);
    _ppMeetingbloc.add(_ppMeetingbloc.value);
  }
  savePPStepMeeting(BuildContext context, ParvaneProcessMeeting data) async{
    if (data.edate.trim().isEmpty || data.mdate.trim().isEmpty || data.res==0 || data.mosavabeno==0 || data.note.trim().isEmpty)
      myAlert(context: context, title: 'خطا', message: 'تمامی مقادیر می بایست مشخص گردد');
    else
      try{
        showWaiting(context);
        data.token = readToken(context);
        await _repository.saveParvaneProcessMeeting(data);
        data.edit = false;
        _ppMeetingbloc.add(_ppMeetingbloc.value); 
        showPPStepMeeting(context, data.ppid, data.ppstepid);
      }
      catch(e){
        myAlert(context: context, title: 'خطا', message: '$e');
      }
      finally{
        hideWaiting(context);
      }
  }
  delPPStepMeeting(BuildContext context, ParvaneProcessMeeting data){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف نظر هیت مدیره می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        data.token = readToken(context);
        await _repository.delParvaneProcessMeeting(data);
        showPPStepMeeting(context, data.ppid, data.ppstepid);
      }
      catch(e){
        myAlert(context: context, title: 'خطا', message: '$e');
      }
      finally{
        hideWaiting(context);
      }
    });
  }

  showPPStepInspection(BuildContext context, int ppid, int stepid) async{
    try{
      _ppInspectionbloc.add(PPInspectionModel(status: Status.loading));
      _ppInspectionbloc.add(PPInspectionModel(status: Status.loaded, rows: await _repository.loadParvaneProcessInspection(ppid, stepid)));
    }
    catch(e){
      _ppInspectionbloc.add(PPInspectionModel(status: Status.error, msg: '$e'));
    }
  }
  editPPStepInspection(ParvaneProcessInspection data){
    _ppInspectionbloc.value.rows.forEach((element)=>element.edit = element.id == data.id && !data.edit);
    _ppInspectionbloc.add(_ppInspectionbloc.value);
  }
  savePPStepInspection(BuildContext context, ParvaneProcessInspection data) async{
    if (data.edate.trim().isEmpty || data.bdate.trim().isEmpty || data.res==0 || data.degree==0 || data.note.trim().isEmpty)
      myAlert(context: context, title: 'خطا', message: 'تمامی مقادیر می بایست مشخص گردد');
    else
      try{
        showWaiting(context);
        data.token = readToken(context);
        await _repository.saveParvaneProcessInspection(data);
        data.edit = false;
        _ppInspectionbloc.add(_ppInspectionbloc.value); 
        showPPStepInspection(context, data.ppid, data.ppstepid);
      }
      catch(e){
        myAlert(context: context, title: 'خطا', message: '$e');
      }
      finally{
        hideWaiting(context);
      }
  }
  delPPStepInspection(BuildContext context, ParvaneProcessInspection data){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف بازرسی می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        data.token = readToken(context);
        await _repository.delParvaneProcessInspection(data);
        showPPStepInspection(context, data.ppid, data.ppstepid);
      }
      catch(e){
        myAlert(context: context, title: 'خطا', message: '$e');
      }
      finally{
        hideWaiting(context);
      }
    });
  }
}