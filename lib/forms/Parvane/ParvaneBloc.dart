import 'package:flutter/material.dart';
import 'package:pama/module/theme-Manager.dart';
import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';
import 'package:rxdart/subjects.dart';
import 'package:provider/provider.dart';

class ParvaneModel{
  Status status;
  List<Parvane> rows;
  String msg;

  ParvaneModel({@required this.status, this.rows, this.msg});
}
class ParvaneMobasherModel{
  Status status;
  List<ParvaneMobasher> rows;
  String msg;

  ParvaneMobasherModel({@required this.status, this.rows, this.msg});
}
class ParvanePartnerModel{
  Status status;
  List<ParvanePartner> rows;
  String msg;

  ParvanePartnerModel({@required this.status, this.rows, this.msg});
}
class ParvanePersonelModel{
  Status status;
  List<ParvanePersonel> rows;
  String msg;

  ParvanePersonelModel({@required this.status, this.rows, this.msg});
}

class ParvaneBloc{
  ParvaneRepository _repository = ParvaneRepository();

  BehaviorSubject<ParvaneModel> _parvane = BehaviorSubject<ParvaneModel>()..add(ParvaneModel(status: Status.initial));
  Stream<ParvaneModel> get stream$ => _parvane.stream;
  ParvaneModel get value$ => _parvane.stream.value;

  BehaviorSubject<ParvaneMobasherModel> _parvaneMobasher = BehaviorSubject<ParvaneMobasherModel>()..add(ParvaneMobasherModel(status: Status.initial));
  Stream<ParvaneMobasherModel> get mobasherstream$ => _parvaneMobasher.stream;
  ParvaneMobasherModel get mobashervalue$ => _parvaneMobasher.stream.value;

  BehaviorSubject<ParvanePartnerModel> _parvanePartner = BehaviorSubject<ParvanePartnerModel>()..add(ParvanePartnerModel(status: Status.initial));
  Stream<ParvanePartnerModel> get partnerstream$ => _parvanePartner.stream;
  ParvanePartnerModel get partnervalue$ => _parvanePartner.stream.value;

  BehaviorSubject<ParvanePersonelModel> _parvanePersonel = BehaviorSubject<ParvanePersonelModel>()..add(ParvanePersonelModel(status: Status.initial));
  Stream<ParvanePersonelModel> get personelstream$ => _parvanePersonel.stream;
  ParvanePersonelModel get personelvalue$ => _parvanePersonel.stream.value;

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

  saveData(BuildContext context, Parvane parvane) async{
    try{
      showWaiting(context);
      parvane.token = readToken(context);
      parvane.cmpid = context.read<ThemeManager>().cmpid;
      int _id = await _repository.saveData(parvane);
      parvane.id = _id;
      parvane.old = _id;
      if (parvane.old == 0)
        _parvane.value.rows.insert(0, parvane);
      else
        _parvane.add(_parvane.value);
    }
    catch(e){
      analyzeError(context, '$e', msg: true);
    }
    finally{
      hideWaiting(context);
    }
  }

  loadMobasher(BuildContext context, int parvaneid) async{
    try{
      _parvaneMobasher.add(ParvaneMobasherModel(status: Status.loading));
      _parvaneMobasher.add(ParvaneMobasherModel(status: Status.loaded, rows: await _repository.loadMObasher(ParvaneMobasher(parvaneid: parvaneid, token: readToken(context)))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _parvaneMobasher.add(ParvaneMobasherModel(status: Status.error, msg: compileErrorMessage('$e')));
    }
  }
  addMobasher(BuildContext context, int parvane, People peop) async{
    try{
      int _id = await _repository.addMobasher(ParvaneMobasher(id: 0, peopid: peop.id, parvaneid: parvane, token: readToken(context)));
      _parvaneMobasher.value.rows.insert(0, ParvaneMobasher(id: _id, parvaneid: parvane, peopid: peop.id, nationalid: peop.nationalid, name: peop.name, family: peop.family, father: peop.father, ss: peop.ss));
      _parvaneMobasher.add(_parvaneMobasher.value);
    }
    catch(e){
      analyzeError(context, '$e', msg: true);
    }
  }
  delMobasher(BuildContext context, ParvaneMobasher mobasher) async{
    confirmMessage(context, 'حذف مباشر', 'آیا مایل به حذف ${mobasher.name} ${mobasher.family} می باشید؟', yesclick: () async{
      try{
        mobasher.token = readToken(context);
        await _repository.delMobasher(mobasher);
        _parvaneMobasher.value.rows.removeWhere((element) => element.id==mobasher.id);
        _parvaneMobasher.add(_parvaneMobasher.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e', msg: true);
      }
    });
  }

  loadPartner(BuildContext context, int parvaneid) async{
    try{
      _parvanePartner.add(ParvanePartnerModel(status: Status.loading));
      _parvanePartner.add(ParvanePartnerModel(status: Status.loaded, rows: await _repository.loadPartner(ParvanePartner(parvaneid: parvaneid, token: readToken(context)))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _parvanePartner.add(ParvanePartnerModel(status: Status.error, msg: compileErrorMessage('$e')));
    }
  }
  addPartner(BuildContext context, ParvanePartner partner){
    if (_parvanePartner.value.rows.where((element) => element.peopid==partner.peopid).length == 0)
      _parvanePartner.value.rows.insert(0, partner);
    _parvanePartner.add(_parvanePartner.value);
  }
  savePartner(BuildContext context, ParvanePartner partner) async{
    if (partner.perc == 0)
      myAlert(context: context, title: 'فیلد اجباری', message: 'درصد شراکت مشخص نشده است');
    else
      try{
        partner.token = readToken(context);
        partner.id = await _repository.addPartner(partner);
        partner.edit = false;
        _parvanePartner.add(_parvanePartner.value);
      }
      catch(e){
        analyzeError(context, '$e', msg: true);
      }
  }
  editPartner(ParvanePartner partner){
    partner.edit = true;
    _parvanePartner.add(_parvanePartner.value);
  }
  delPartner(BuildContext context, ParvanePartner partner) async{
    confirmMessage(context, 'حذف شریک', 'آیا مایل به حذف ${partner.name} ${partner.family} می باشید؟', yesclick: () async{
      try{
        partner.token = readToken(context);
        await _repository.delPartner(partner);
        _parvanePartner.value.rows.removeWhere((element) => element.peopid==partner.peopid);
        _parvanePartner.add(_parvanePartner.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e', msg: true);
      }
    });
  }

  loadPersonel(BuildContext context, int parvaneid) async{
    try{
      _parvanePersonel.add(ParvanePersonelModel(status: Status.loading));
      _parvanePersonel.add(ParvanePersonelModel(status: Status.loaded, rows: await _repository.loadPersonel(ParvanePersonel(parvaneid: parvaneid, token: readToken(context)))));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _parvanePersonel.add(ParvanePersonelModel(status: Status.error, msg: compileErrorMessage('$e')));
    }
  }
  addPersonel(BuildContext context, ParvanePersonel personel){
    if (_parvanePersonel.value.rows.where((element) => element.id==personel.id).length == 0)
      _parvanePersonel.value.rows.insert(0, personel);
    _parvanePersonel.add(_parvanePersonel.value);
  }
  savePersonel(BuildContext context, ParvanePersonel personel) async{
    try{
      personel.token = readToken(context);
      personel.id = await _repository.addPersonel(personel);
      personel.edit = false;
      _parvanePersonel.add(_parvanePersonel.value);
    }
    catch(e){
      analyzeError(context, '$e', msg: true);
    }
  }
  editPersonel(ParvanePersonel personel){
    personel.edit = true;
    _parvanePersonel.add(_parvanePersonel.value);
  }
  delPersonel(BuildContext context, ParvanePersonel personel) async{
    confirmMessage(context, 'حذف پرسنل', 'آیا مایل به حذف ${personel.name} ${personel.family} می باشید؟', yesclick: () async{
      try{
        personel.token = readToken(context);
        await _repository.delPersonel(personel);
        _parvanePersonel.value.rows.removeWhere((element) => element.id==personel.id);
        _parvanePersonel.add(_parvanePersonel.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e', msg: true);
      }
    });
  }
}