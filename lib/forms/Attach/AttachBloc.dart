import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class AttachDataModel{
  Status status;
  List<Attach> rows;
  String msg;

  AttachDataModel({@required this.status, this.rows, this.msg});
}

class AttachBloc{
  AttachRepository _repository = AttachRepository();

  BehaviorSubject<AttachDataModel> _attachBloc = BehaviorSubject<AttachDataModel>.seeded(AttachDataModel(status: Status.loading));
  Stream<AttachDataModel> get attachStream$ => _attachBloc.stream;
  List<Attach> get rows$ => _attachBloc.stream.value.rows;

  loadData(BuildContext context, String tag, {int cmpid = 0, int id1 = 0, int id2 = 0, int id3 = 0, int id4 = 0, int id5 = 0}) async{
    try{
      _attachBloc.add(AttachDataModel(status: Status.loading));
      _attachBloc.add(AttachDataModel(status: Status.loaded, rows: await _repository.load(readToken(context), {'tag': tag, 'cmpid': cmpid, 'id1': id1, 'id2': id2, 'id3': id3, 'id4': id4, 'id5': id5})));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _attachBloc.add(AttachDataModel(status: Status.error, msg: '$e'));
    }
  }
}