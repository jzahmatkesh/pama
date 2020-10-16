import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class AddInfoModel{
  Status status;
  List<AddInfo> rows;
  String msg; 

  AddInfoModel({this.status, this.rows, this.msg});
}

class AddInfoNoteModel{
  Status status;
  List<AddInfoNote> rows;
  String msg; 

  AddInfoNoteModel({this.status, this.rows, this.msg});
}

class AddInfoBloc{
  AddInfoRepository _repository = new AddInfoRepository();

  BehaviorSubject<AddInfoModel> _addinfoBloc = BehaviorSubject<AddInfoModel>.seeded(AddInfoModel(status: Status.loading));
  Stream<AddInfoModel> get addinfoStream$ => _addinfoBloc.stream;

  BehaviorSubject<AddInfoNoteModel> _noteBloc = BehaviorSubject<AddInfoNoteModel>.seeded(AddInfoNoteModel(status: Status.loading));
  Stream<AddInfoNoteModel> get noteStream$ => _noteBloc.stream;

  loadData(BuildContext context) async{
    try{
      _addinfoBloc.add(AddInfoModel(status: Status.loading));
      _addinfoBloc.add(AddInfoModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _addinfoBloc.add(AddInfoModel(status: Status.error, msg: '$e'));
    }
  }

  newAddInfo(){
    bool nw = true;
    _addinfoBloc.value.rows.forEach((element) {
      if (element.edit)
        nw = false;
    });
    if (nw){
      _addinfoBloc.value.rows.insert(0, AddInfo(id: 0, name: '', kind: 1, edit: true));
      _addinfoBloc.add(_addinfoBloc.value);
    }
  }

  setMode(BuildContext context, int id, int kind){
    _addinfoBloc.value.rows.forEach((element) {
      if (element.id == id){
        element.edit = kind == 1 && !element.edit;
        element.notes = kind == 2 && !element.notes;
        element.forms = kind == 3 && !element.forms;
      }
      else{
        element.edit = false;
        element.notes = false;
        element.forms = false;
      }
      if (kind == 2)
        loadNotes(context, id);
    });
    _addinfoBloc.add(_addinfoBloc.value);
  }

  search(String val){
    _addinfoBloc.value.rows.forEach((element) {
      element.insearch = element.name.contains(val);
    });
    _addinfoBloc.add(_addinfoBloc.value);
  }

  changeKind(int id, int val){
    _addinfoBloc.value.rows.forEach((element) {
      if (element.id == id)
        element.kind = val;
    });
    _addinfoBloc.add(_addinfoBloc.value);
  }

  saveAddInfo(BuildContext context, AddInfo addinfo) async{
    if (addinfo.name.trim().isEmpty)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان اطلاعات تکمیلی مشخص نشده است');
    else
      try{
        showWaiting(context);
        addinfo.token = readToken(context);
        int id = await _repository.save(addinfo);
        _addinfoBloc.value.rows.forEach((element) {
          if (element.id == addinfo.id){
            element.id = id;
            element.name = addinfo.name;
            element.kind = addinfo.kind;
            element.edit = false;
          }
        });
        _addinfoBloc.add(_addinfoBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  setdublicate(BuildContext context, AddInfo addinfo, bool val) async{
    try{
      addinfo.token = readToken(context);
      addinfo.dublicate = val;
      int dub = await _repository.setDublicate(addinfo);
      _addinfoBloc.value.rows.forEach((element) {
        if (element.id == addinfo.id)
          element.dublicate = dub == 1;
      });
      _addinfoBloc.add(_addinfoBloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }
  
  delAddInfo(BuildContext context, AddInfo addinfo){
    confirmMessage(context, 'تایید حذف', "آیا مایل به حذف ${addinfo.name} می باشید؟", yesclick: () async{
      try{
        addinfo.token = readToken(context);
        if (await _repository.delete(addinfo))
          _addinfoBloc.value.rows.removeWhere((element) => element.id==addinfo.id);
        _addinfoBloc.add(_addinfoBloc.value);
      }
      catch(e){
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  loadNotes(BuildContext context, int id) async{
    try{
      _noteBloc.add(AddInfoNoteModel(status: Status.loading));
      _noteBloc.add(AddInfoNoteModel(status: Status.loaded, rows: await _repository.loadNote(readToken(context), id)));
    }
    catch(e){
      _noteBloc.add(AddInfoNoteModel(status: Status.error, msg: '$e'));
    }
  }
  newNote(int addid){
    bool nw = true;
    _noteBloc.value.rows.forEach((element) {
      if (element.id == 0)
        nw = false;
      element.edit = false;
    });
    if (nw){
      _noteBloc.value.rows.insert(0, new AddInfoNote(id: 0, note: '', edit: true));
      _noteBloc.add(_noteBloc.value);
    }
  }
  editNote(AddInfoNote note){
    _noteBloc.value.rows.forEach((element) {
      if (element.id == note.id)
        element.edit = true;
      else if (element.id > 0)
        element.edit = false;
    });
    _noteBloc.add(_noteBloc.value);
  }
  saveNote(BuildContext context, int addid, AddInfoNote note) async{
    if (note.note.trim().isEmpty)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'مقدار پیش فرض مشخص نشده است');
    else
      try{
        showWaiting(context);
        note.token = readToken(context);
        note.addid  = addid;
        int id = await _repository.saveNote(note);
        _noteBloc.value.rows.forEach((element) {
          if (element.id == note.id){
            element.id = id;
            element.note = note.note;
            element.edit = false;
          }
        });
        _noteBloc.add(_noteBloc.value);
        hideWaiting(context);
        myAlert(context: context, title: 'ذخیره', message: 'ذخیره اطلاعات با موفقیت انجام گردید', color: Colors.green);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }
  delNote(BuildContext context, int addid, AddInfoNote note){
    confirmMessage(context, 'تایید حذف', "آیا مایل به حذف ${note.note} می باشید؟", yesclick: () async{
      try{
        note.addid = addid;
        note.token = readToken(context);
        if (await _repository.deleteNote(note))
          _noteBloc.value.rows.removeWhere((element) => element.id==note.id);
        _noteBloc.add(_noteBloc.value);
      }
      catch(e){
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }
}

