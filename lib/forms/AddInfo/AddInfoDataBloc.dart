import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class AddInfoDataModel{
  Status status;
  List<AddInfoData> rows;
  String msg;

  AddInfoDataModel({@required this.status, this.rows, this.msg});
}

class AddinfoDataBloc{
  AddinfoDataRepository _repository = AddinfoDataRepository();

  BehaviorSubject<AddInfoDataModel> _addinfodataBloc = BehaviorSubject<AddInfoDataModel>.seeded(AddInfoDataModel(status: Status.loading));
  Stream<AddInfoDataModel> get addinfoDataStream$ => _addinfodataBloc.stream;
  List<AddInfoData> get rows$ => _addinfodataBloc.stream.value.rows;

  loadData(BuildContext context, String url, Map<String, String> header) async{
    try{
      _addinfodataBloc.add(AddInfoDataModel(status: Status.loading));
      _addinfodataBloc.add(AddInfoDataModel(status: Status.loaded, rows: await _repository.load(readToken(context), url, header)));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _addinfodataBloc.add(AddInfoDataModel(status: Status.error, msg: '$e'));
    }
  }

  setEdit(AddInfoData add){
    _addinfodataBloc.value.rows.forEach((element) {
      element.edit = element.addid == add.addid;
    });
    _addinfodataBloc.add(_addinfodataBloc.value);
  }

  newData(BuildContext context, int kind, int addid, String name, String val, String url, Map<String, String> header, {bool pop = true}) async{
    try{
      await _repository.save(new AddInfoData(addid: addid, token: readToken(context), note: val), url, header);
      bool valid = false;
      _addinfodataBloc.value.rows.forEach((element){
        if (element.addid == addid){
          element.note = val;
          element.edit = false;
          valid = true;
        }
      });
      if (!valid)
        _addinfodataBloc.value.rows.insert(0, AddInfoData(addid: addid, edit: false, kind: kind, name: name, note: val));
      _addinfodataBloc.add(_addinfodataBloc.value);
      if (pop)
        Navigator.pop(context);
    }
    catch(e){
      analyzeError(context, '$e');
    }
 }

 delData(BuildContext context, AddInfoData addinfo, String url, Map<String, String> header, {bool pop = true}){
   confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف ${addinfo.name} می باشید؟', yesclick: () async{
    try{
      header.putIfAbsent('token', () => readToken(context));
      header.remove('addid');
      header.putIfAbsent('addid', () => addinfo.addid.toString());
      if (await _repository.del(url, header)){
        _addinfodataBloc.value.rows.removeWhere((element) => element.addid == addinfo.addid);
        _addinfodataBloc.add(_addinfodataBloc.value);
      }
    }
    catch(e){
      analyzeError(context, '$e');
    }
    Navigator.pop(context);
   });
 }

}