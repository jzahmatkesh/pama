import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class CommitteeModel{
  Status status;
  List<Committee> rows;
  String msg;

  CommitteeModel({@required this.status, this.rows, this.msg});
}
class CommitteeMemberModel{
  Status status;
  List<CommitteeMember> rows;
  String msg;

  CommitteeMemberModel({@required this.status, this.rows, this.msg});
}
class CommitteeDetailModel{
  Status status;
  List<CommitteeDetail> rows;
  String msg;

  CommitteeDetailModel({@required this.status, this.rows, this.msg});
}
class CommitteeDetailAbsentModel{
  Status status;
  List<CommitteeDetailAbsent> rows;
  String msg;

  CommitteeDetailAbsentModel({@required this.status, this.rows, this.msg});
}
class CommitteeDetailMosavabatModel{
  Status status;
  List<CommitteeDetailMosavabat> rows;
  String msg;

  CommitteeDetailMosavabatModel({@required this.status, this.rows, this.msg});
}

class CommitteeBloc{

  CommitteeRepository _repository = CommitteeRepository();

  BehaviorSubject<CommitteeModel> _committeebloc = BehaviorSubject<CommitteeModel>.seeded(CommitteeModel(status: Status.loading));
  Stream<CommitteeModel> get committeeStream$ => _committeebloc.stream;

  BehaviorSubject<int> _newCommitteeKind = BehaviorSubject<int>.seeded(1);
  Stream<int> get newCommitteeKindStream$ => _newCommitteeKind.stream;

  BehaviorSubject<CommitteeMemberModel> _committeeMemberbloc = BehaviorSubject<CommitteeMemberModel>.seeded(CommitteeMemberModel(status: Status.loading));
  Stream<CommitteeMemberModel> get committeeMemberStream$ => _committeeMemberbloc.stream;

  BehaviorSubject<CommitteeDetailModel> _committeeDetailbloc = BehaviorSubject<CommitteeDetailModel>.seeded(CommitteeDetailModel(status: Status.loading));
  Stream<CommitteeDetailModel> get committeeDetailStream$ => _committeeDetailbloc.stream;

  BehaviorSubject<CommitteeDetailAbsentModel> _committeeDetailAbsentbloc = BehaviorSubject<CommitteeDetailAbsentModel>.seeded(CommitteeDetailAbsentModel(status: Status.loading));
  Stream<CommitteeDetailAbsentModel> get committeeDetailAbsentStream$ => _committeeDetailAbsentbloc.stream;

  BehaviorSubject<CommitteeDetailMosavabatModel> _committeeDetailMosavabatbloc = BehaviorSubject<CommitteeDetailMosavabatModel>.seeded(CommitteeDetailMosavabatModel(status: Status.loading));
  Stream<CommitteeDetailMosavabatModel> get committeeDetailMosavabatStream$ => _committeeDetailMosavabatbloc.stream;

  load(BuildContext context, int cmpid) async{
    try{
      _committeebloc.add(CommitteeModel(status: Status.loading));
      _committeebloc.add(CommitteeModel(status: Status.loaded, rows: await _repository.load(readToken(context), cmpid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _committeebloc.add(CommitteeModel(status: Status.error, msg: '$e'));
    }
    }

  setnewCommitteeKind(int i){
    _newCommitteeKind.add(i);
  }

  newCommittee(BuildContext context, int cmpid){
    _committeebloc.value.rows.forEach((element) => element.edit = false);
    _committeebloc.value.rows.insert(0, Committee(cmpid: cmpid, empid: 0, empfamily: '', id: 0, kind: 1, name: '', edit: true));
    _committeebloc.add(_committeebloc.value);
  }

  editMode(Committee com, {bool member = false, bool detail = false}){
    _committeebloc.value.rows.forEach((element){
      element.edit = member || detail ? false : element.id == com.id ? !element.edit : false;
      element.member = !member ? false : element.id == com.id ? !element.member : false;
      element.detail = !detail ? false : element.id == com.id ? !element.detail : false;
    });
    _committeebloc.add(_committeebloc.value);
  }

  saveCommittee(BuildContext context, Committee com) async{
    if (com.name.isEmpty)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'عنوان مشخص نشده است');
    else if (com.empid == 0)
      myAlert(context: context, title: 'مقادیر اجباری', message: 'کارشناس مشخص نشده است');
    else
    try{
      com.token = readToken(context);
      int id = await _repository.save(com);
      _committeebloc.value.rows.forEach((element) {
        if (com.id == element.id){
          element.id = id;
          element.edit = false;
        }
      });
      _committeebloc.add(_committeebloc.value);
      myAlert(context: context, title: 'ذخیره', message: 'با موفقیت انجام گردید', color: Colors.green);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }




  delCommittee(BuildContext context, Committee com){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${com.name} می باشید؟', yesclick: () async{
      try{
        await _repository.delete(readToken(context), com);
        _committeebloc.value.rows.removeWhere((element) => element.id == com.id);
        _committeebloc.add(_committeebloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${com.name} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  loadMember(BuildContext context, int cmpid, int cmtid) async{
    try{
      _committeeMemberbloc.add(CommitteeMemberModel(status: Status.loading));
      _committeeMemberbloc.add(CommitteeMemberModel(status: Status.loaded, rows: await _repository.loadMember(readToken(context), cmpid, cmtid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _committeeMemberbloc.add(CommitteeMemberModel(status: Status.error, msg: '$e'));
    }
 }

  addMember(BuildContext context, int cmpid, int cmtid, int peopid, String name, String family){
    bool _nv = true;
    _committeeMemberbloc.value.rows.forEach((element) {
      if (element.peopid == peopid){
        element.edit = true;
        _nv = false;
      }
      else
        element.edit = false;
    });
    if (_nv)
      _committeeMemberbloc.value.rows.insert(0, CommitteeMember(cmpid: cmpid, cmtid: cmtid, peopid: peopid, name: name, family: family, semat: 1, edit: true));
    _committeeMemberbloc.add(_committeeMemberbloc.value);
  }

  changeSemat(CommitteeMember mem, int semat){
    bool _valid = false;
    _committeeMemberbloc.value.rows.forEach((element) {
      if (element.peopid == mem.peopid){
        element.semat = semat;
        _valid = true;
      }
    });
    if (_valid)
      _committeeMemberbloc.add(_committeeMemberbloc.value);
  }

  saveMember(BuildContext context, CommitteeMember mem) async{
    try{
      showWaiting(context);
      mem.token = readToken(context);
      await _repository.saveMember(mem);
      _committeeMemberbloc.value.rows.forEach((element) => element.edit = false);
      _committeeMemberbloc.add(_committeeMemberbloc.value);
      hideWaiting(context);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }

  delMember(BuildContext context, CommitteeMember mem){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${mem.name} ${mem.family} می باشید؟', yesclick: () async{
      try{
        await _repository.deleteMember(readToken(context), mem);
        _committeeMemberbloc.value.rows.removeWhere((element) => element.peopid == mem.peopid);
        _committeeMemberbloc.add(_committeeMemberbloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${mem.name} ${mem.family} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }



  loadDetail(BuildContext context, int cmpid, int cmtid) async{
    try{
      _committeeDetailbloc.add(CommitteeDetailModel(status: Status.loading));
      _committeeDetailbloc.add(CommitteeDetailModel(status: Status.loaded, rows: await _repository.loadDetail(readToken(context), cmpid, cmtid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _committeeDetailbloc.add(CommitteeDetailModel(status: Status.error, msg: '$e'));
    }
  }

  saveDetail(BuildContext context, CommitteeDetail dtl) async{
    try{
      showWaiting(context);
      dtl.token = readToken(context);
      int _id = await _repository.saveDetail(dtl);
      _committeeDetailbloc.value.rows.forEach((element) => element.edit = false);
      if (dtl.id == 0){
        dtl.id = _id;
        dtl.edit = false;
        _committeeDetailbloc.value.rows.insert(0, dtl);
      }
      _committeeDetailbloc.add(_committeeDetailbloc.value);
      hideWaiting(context);
      Navigator.pop(context);
      myAlert(context: context, title: 'ذخیره', message: 'با موفقیت انجام گردید', color: Colors.green);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }

  delDetail(BuildContext context, CommitteeDetail dtl){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${dtl.title} می باشید؟', yesclick: () async{
      try{
        await _repository.deleteDetail(readToken(context), dtl);
        _committeeDetailbloc.value.rows.removeWhere((element) => element.id == dtl.id);
        _committeeDetailbloc.add(_committeeDetailbloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${dtl.empfamily} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  setDetailMode(BuildContext context, CommitteeDetail dtl, {bool absend = false, bool mosavabat = false}){
    _committeeDetailbloc.value.rows.forEach((element) {
      if (element.id == dtl.id){
        element.absent = !absend ? false : !element.absent;
        element.mosavabat = !mosavabat ? false : !element.mosavabat;
        if (element.absent)
          loadDetailAbsent(context, element);       
        if (element.mosavabat)
          loadDetailMosavabat(context, element);       
      }
    });
    _committeeDetailbloc.add(_committeeDetailbloc.value);
  }

  loadDetailAbsent(BuildContext context, CommitteeDetail dtl) async{
    try{
      _committeeDetailAbsentbloc.add(CommitteeDetailAbsentModel(status: Status.loading));
      _committeeDetailAbsentbloc.add(CommitteeDetailAbsentModel(status: Status.loaded, rows: await _repository.loadDetailAbsent(readToken(context), dtl.cmpid, dtl.cmtid, dtl.id)));
    }
    catch(e){
      analyzeError(context, '$e');
      _committeeDetailAbsentbloc.add(CommitteeDetailAbsentModel(status: Status.error, msg: '$e'));
    }
  }

  addDetailAbsent(BuildContext context, CommitteeDetailAbsent abs, int detailid) async{
    try{
      abs.token = readToken(context);
      abs.detailid = detailid;
      await _repository.saveDetailAbsent(abs);
      _committeeDetailAbsentbloc.value.rows.forEach((element) {
        if (element.peopid == abs.peopid){
          element.detailid = detailid;
        }
      });
      _committeeDetailAbsentbloc.add(_committeeDetailAbsentbloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }

  delDetailAbsent(BuildContext context, CommitteeDetailAbsent abs) async{
    try{
      await _repository.deleteDetailAbsent(readToken(context), abs);
      _committeeDetailAbsentbloc.value.rows.forEach((element) {
        if (element.peopid == abs.peopid){
          element.detailid = 0;
        }
      });
      _committeeDetailAbsentbloc.add(_committeeDetailAbsentbloc.value);
    }catch(e){
      analyzeError(context, '$e');
    }
  }

  loadDetailMosavabat(BuildContext context, CommitteeDetail dtl) async{
    try{
      _committeeDetailMosavabatbloc.add(CommitteeDetailMosavabatModel(status: Status.loading));
      _committeeDetailMosavabatbloc.add(CommitteeDetailMosavabatModel(status: Status.loaded, rows: await _repository.loadDetailMosavabat(readToken(context), dtl.cmpid, dtl.cmtid, dtl.id)));
    }
    catch(e){
      analyzeError(context, '$e');
      _committeeDetailMosavabatbloc.add(CommitteeDetailMosavabatModel(status: Status.error, msg: '$e'));
    }
  }

  saveDetailMosavabat(BuildContext context, CommitteeDetailMosavabat mos) async{
    try{
      showWaiting(context);
      mos.token = readToken(context);
      int _id = await _repository.saveDetailMosavabat(mos);
      if (mos.id == 0){
        mos.id = _id;
        _committeeDetailMosavabatbloc.value.rows.insert(0, mos);
      }
      else 
        _committeeDetailMosavabatbloc.value.rows.forEach((element) {
          if (element.id == mos.id)
            element = mos;
        });
      _committeeDetailMosavabatbloc.add(_committeeDetailMosavabatbloc.value);
      hideWaiting(context);
      Navigator.pop(context);
      myAlert(context: context, title: 'ذخیره', message: 'با موفقیت انجام گردید', color: Colors.green);
    } 
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }   
  }

  delDetailMosavabat(BuildContext context, CommitteeDetailMosavabat mos){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${mos.title} می باشید؟', yesclick: () async{
      try{
        await _repository.deleteDetailMosavabat(readToken(context), mos);
        _committeeDetailMosavabatbloc.value.rows.removeWhere((element) => element.id == mos.id);
        _committeeDetailMosavabatbloc.add(_committeeDetailMosavabatbloc.value);
      }catch(e){
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }
}