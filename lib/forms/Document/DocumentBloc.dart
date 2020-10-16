import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class DocumentModel{
  Status status;
  List<Document> rows;
  String msg;

  DocumentModel({this.status, this.rows, this.msg});
}

class DocumentBloc{
  DocumentRepository _repository = new DocumentRepository();
  
  BehaviorSubject<DocumentModel> _documentkbloc = BehaviorSubject<DocumentModel>.seeded(DocumentModel(status: Status.loading));
  Stream<DocumentModel> get documentkStream$ => _documentkbloc.stream;

  loadData(BuildContext context) async{
    try{
      _documentkbloc.add(DocumentModel(status: Status.loading));
      _documentkbloc.add(DocumentModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _documentkbloc.add(DocumentModel(status: Status.error, msg: '$e'));
    }
  }

  saveDocument(BuildContext context, Document doc) async{
    if (doc.name.trim().isEmpty) 
      myAlert(context: context, title: "خطا", message: "عنوان مدرک مشخص نشده است");
    else
      try{
        showWaiting(context);
        doc.token = readToken(context);
        int id = await _repository.save(doc);
        bool nw = true;
        _documentkbloc.value.rows.forEach((element) {
          if (element.id == id){
            element.editing = false;
            nw = false;
          }
        });
        if (nw)
          _documentkbloc.value.rows.forEach((element) {
            if (element.id == 0){
              element.editing = false;
              element.id = id;
              element.name = doc.name;
              nw = false;
            }
          });
        _documentkbloc.add(_documentkbloc.value);
        myAlert(context: context, title: "ذخیره", message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.green);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
  }

  newDocument(BuildContext context){
    _documentkbloc.value.rows.insert(0, new Document(id: 0, name: ""));
    _documentkbloc.add(_documentkbloc.value);
  }

  delDocument(BuildContext context, Document doc){
    confirmMessage(context, 'تایید حذف', "آیا مایل به حذف ${doc.name} می باشید؟", yesclick: () async{
      try{
        showWaiting(context);
        doc.token = readToken(context);
        await _repository.delete(doc);
        _documentkbloc.value.rows.removeWhere((element) => element.id == doc.id);
        _documentkbloc.add(_documentkbloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  editMode(Document doc){
    _documentkbloc.value.rows.forEach((element) {
      element.editing = element.id == doc.id;
    });
    _documentkbloc.add(_documentkbloc.value);
  }

  setExpDate(BuildContext context, Document doc, bool val) async{
    try{
      doc.token = readToken(context);
      doc.expdate = val ? 1 : 0;
      await _repository.setExpDate(doc);
      _documentkbloc.value.rows.forEach((element) {
        if (element.id == doc.id)
          element.expdate = doc.expdate;
      });
      _documentkbloc.add(_documentkbloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }
}