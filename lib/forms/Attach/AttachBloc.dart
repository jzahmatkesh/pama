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

  final String tag;
  final int cmpid;
  final int id1;
  final int id2;
  final int id3;
  final int id4;
  final int id5;

  AttachBloc({this.tag, this.cmpid=0, this.id1=0, this.id2=0, this.id3=0, this.id4=0, this.id5=0});

  loadData(BuildContext context) async{
    try{
      _attachBloc.add(AttachDataModel(status: Status.loading));
      _attachBloc.add(AttachDataModel(status: Status.loaded, rows: await _repository.load(readToken(context), {'tag': tag, 'cmpid': cmpid, 'id1': id1, 'id2': id2, 'id3': id3, 'id4': id4, 'id5': id5})));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _attachBloc.add(AttachDataModel(status: Status.error, msg: '$e'));
    }
  }

  // reLoad(BuildContext context) async{
  //   try{
  //     _attachBloc.add(AttachDataModel(status: Status.loading));
  //     _attachBloc.add(AttachDataModel(status: Status.loaded, rows: await _repository.load(readToken(context), {'tag': this.tag, 'cmpid': cmpid, 'id1': id1, 'id2': id2, 'id3': id3, 'id4': id4, 'id5': id5})));
  //   }
  //   catch(e){
  //     analyzeError(context, '$e', msg: false);
  //     _attachBloc.add(AttachDataModel(status: Status.error, msg: '$e'));
  //   }
  // }

  delAttach(BuildContext context, int id) async{
    confirmMessage(context, 'حذف کارمند', 'آیا مایل به حذف فایل ضمیمه انتخابی می باشید؟', yesclick: () async{
      try{
        await _repository.del({'token': readToken(context), 'radif': id.toString(), 'prm': tag});
        _attachBloc.value.rows.removeWhere((element) => element.radif == id);
        _attachBloc.add(_attachBloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف فایل ضمیمه با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
}