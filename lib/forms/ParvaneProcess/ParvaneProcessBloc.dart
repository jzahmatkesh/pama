import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';
import '../../module/theme-Manager.dart';

class PPrcModel{
  Status status;
  List<Process> rows;
  String msg;

  PPrcModel({@required this.status, this.rows, this.msg});
}

class PPrcBloc{
  ParvaneRepository _repository = ParvaneRepository();
    
  BehaviorSubject<PPrcModel> _bloc = BehaviorSubject<PPrcModel>();
  Stream<PPrcModel> get stream => _bloc.stream;
  PPrcModel get value => _bloc.value;

  loadProcess({BuildContext context, int parvaneID}) async{
    try{
      _bloc.add(PPrcModel(status: Status.loading));
      _bloc.add(PPrcModel(status: Status.loaded, rows: await _repository.loadParvaneNewProcess(Parvane(token: readToken(context), cmpid: context.read<ThemeManager>().cmpid, id: parvaneID))));
    }
    catch(e){
      _bloc.add(PPrcModel(status: Status.error, msg: '$e'));
    }
  }
}