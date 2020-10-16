import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';

class CompanyUserModel{
  Status status;
  List<CompanyUser> rows;
  String msg;

  CompanyUserModel({this.status, this.rows, this.msg});
}
class CompanyModel{
  Status status;
  List<Company> rows;
  String msg;

  CompanyModel({this.status, this.rows, this.msg});
}
class CompanyUserGroupModel{
  Status status;
  List<CompanyUserGroups> rows;
  String msg;

  CompanyUserGroupModel({this.status, this.rows, this.msg});
}
class EmployeeModel{
  Status status;
  List<Employee> rows;
  String msg;

  EmployeeModel({this.status, this.rows, this.msg});
}
class EmpFamilyModel{
  Status status;
  List<EmpFamily> rows;
  String msg;

  EmpFamilyModel({this.status, this.rows, this.msg});
}
class DirectorModel{
  Status status;
  List<Director> rows;
  String msg;

  DirectorModel({this.status, this.rows, this.msg});
}
class DrtFamilyModel{
  Status status;
  List<DrtFamily> rows;
  String msg;

  DrtFamilyModel({this.status, this.rows, this.msg});
}

class CompanyBloc{
  BehaviorSubject<CompanyModel> _companybloc = BehaviorSubject<CompanyModel>.seeded(CompanyModel(status: Status.loading));
  Stream<CompanyModel> get companyListStream$ => _companybloc.stream;

  CompanyRepository _repository = CompanyRepository();

  BehaviorSubject<Status> _saveCompany = BehaviorSubject<Status>.seeded(Status.initial);
  Stream<Status> get saveCompanyStream$ => _saveCompany.stream;

  BehaviorSubject<int> _priceStream = BehaviorSubject<int>.seeded(1);
  Stream<int> get pricestream$ => _priceStream.stream;

  BehaviorSubject<CompanyUserModel> _companyUserbloc = BehaviorSubject<CompanyUserModel>.seeded(CompanyUserModel(status: Status.loading));
  Stream<CompanyUserModel> get companyUserStream$ => _companyUserbloc.stream;
  List<CompanyUser> get companyUsers$ => _companyUserbloc.stream.value.rows;

  BehaviorSubject<CompanyUserGroupModel> _companyUserGroupbloc = BehaviorSubject<CompanyUserGroupModel>.seeded(CompanyUserGroupModel(status: Status.loading));
  Stream<CompanyUserGroupModel> get companyUserGroupStream$ => _companyUserGroupbloc.stream;

  BehaviorSubject<EmployeeModel> _employeebloc = BehaviorSubject<EmployeeModel>.seeded(EmployeeModel(status: Status.loading));
  Stream<EmployeeModel> get employeeStream$ => _employeebloc.stream;
  List<Employee> get companyEmployee$ => _employeebloc.value.rows;
  BehaviorSubject<EmpFamilyModel> _empfamilybloc = BehaviorSubject<EmpFamilyModel>.seeded(EmpFamilyModel(status: Status.loading));
  Stream<EmpFamilyModel> get empfamilyStream$ => _empfamilybloc.stream;
  List<EmpFamily> get companyEmpFamily$ => _empfamilybloc.value.rows;

  BehaviorSubject<Employee> _newemployeebloc = BehaviorSubject<Employee>();
  Stream<Employee> get newemployeeStream$ => _newemployeebloc.stream;

  BehaviorSubject<EmpFamily> _newempFamilybloc = BehaviorSubject<EmpFamily>();
  Stream<EmpFamily> get newempFamilyStream$ => _newempFamilybloc.stream;

  BehaviorSubject<DirectorModel> _directorbloc = BehaviorSubject<DirectorModel>.seeded(DirectorModel(status: Status.loading));
  Stream<DirectorModel> get directorStream$ => _directorbloc.stream;
  List<Director> get companydirector$ => _directorbloc.value.rows;
  BehaviorSubject<DrtFamilyModel> _drtfamilybloc = BehaviorSubject<DrtFamilyModel>.seeded(DrtFamilyModel(status: Status.loading));
  Stream<DrtFamilyModel> get drtfamilyStream$ => _drtfamilybloc.stream;
  List<DrtFamily> get companydrtFamily$ => _drtfamilybloc.value.rows;
  BehaviorSubject<Director> _newdirectorbloc = BehaviorSubject<Director>();
  Stream<Director> get newdirectorStream$ => _newdirectorbloc.stream;
  BehaviorSubject<DrtFamily> _newdrtFamilybloc = BehaviorSubject<DrtFamily>();
  Stream<DrtFamily> get newdrtFamilyStream$ => _newdrtFamilybloc.stream;


  loadCompany(BuildContext context, ) async{
    try {
      _companybloc.add(CompanyModel(status: Status.loading));
      _companybloc.add(CompanyModel(status: Status.loaded, rows: await _repository.loadCompanys(readToken(context))));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _companybloc.add(CompanyModel(status: Status.error, msg: '$e'));
    }
  }

  searchByName(String val){
    _companybloc.value.rows.forEach((element) {
      element.insearchquery =  element.name.contains(val) || element.address.contains(val) || element.tel.contains(val);
    });
    _companybloc.add(_companybloc.value);
  }

  showcompanyInfo(int id){
    _companybloc.value.rows.forEach((element) {
      if (element.id == id)
        element.showinfo = !element.showinfo;
      else
        element.showinfo = false;
    });
    _companybloc.add(_companybloc.value);
  }

  setActive(BuildContext context, int id){
      _companybloc.value.rows.forEach((element) async { 
        if (element.id == id){
          try{
            await _repository.setCompanyActive(readToken(context), element);
            element.active = element.active == 0 ? 1 : 0;
            _companybloc.add(_companybloc.value);
          }catch(e){
            analyzeError(context, e.toString());
            // _companybloc.add(CompanyModel(status: Status.error, msg: 'خطا $e'));
          }
        }
      });  
  }

  saveCompanyInfo(BuildContext context, Company company) async{
    _saveCompany.add(Status.loading);
    showWaiting(context);
    try{
      int id = await _repository.saveCompany(readToken(context), company);
      bool nw = true;
      _companybloc.value.rows.forEach((element) {
        if (element.id == id){
          element = company;
          nw = false;
        }
      });
      if (nw){
        company.id = id;
        _companybloc.value.rows.insert(0, company);
      }
      _saveCompany.add(Status.loaded);
      _companybloc.add(_companybloc.value);
      hideWaiting(context);
      Navigator.of(context).pop();
      myAlert(context: context, title: 'ذخیره', message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.lightGreen);
    }catch(e){
      hideWaiting(context);
      _saveCompany.add(Status.error);
      analyzeError(context, e.toString());
    }
  }

  setprice(int price){
    _priceStream.add(price);
  }

  loadCompanyUser(BuildContext context, int cmpid) async{
    try {
      _companyUserbloc.add(CompanyUserModel(status: Status.loading));
      _companyUserbloc.add(CompanyUserModel(status: Status.loaded, rows: await _repository.loadCompanyUsers(readToken(context),cmpid)));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _companyUserbloc.add(CompanyUserModel(status: Status.error, msg: 'خطا $e'));
    }
  }
  setCompanyUserActive(BuildContext context, int cmp, CompanyUser user){
      _companyUserbloc.value.rows.forEach((element) async { 
        if (element.id == user.id){
          try{
            await _repository.setCompanyUserActive(readToken(context), cmp, user);
            element.active = !element.active;
            _companyUserbloc.add(_companyUserbloc.value);
          }catch(e){
            analyzeError(context, e.toString());
            // _companybloc.add(CompanyModel(status: Status.error, msg: 'خطا $e'));
          }
        }
      });  
  }
  deleteCompanyUser(BuildContext context, int cmp, int user){
    confirmMessage(context, 'حذف کاربر', 'آیا مایل به حذف کاربر زحمتکش می باشید؟', yesclick: () async{
      try{
        await _repository.delCompanyUser(readToken(context), cmp, user);
        _companyUserbloc.value.rows.removeWhere((element) => element.id == user);
        _companyUserbloc.add(_companyUserbloc.value);
      }catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
  setCompanyUserPass(BuildContext context, int cmp, int user, int peopid, String pass, String pass2) async{
    try{
    if (pass.isEmpty)
      myAlert(context: context, title: "خطا", message: "رمز عبور مشخص نشده است");
    else if (pass.trim() != pass2.trim())
      myAlert(context: context, title: "خطا", message: "تکرار رمز عبور صحیح نمی باشد");
    else if (pass.length < 6)
      myAlert(context: context, title: "خطا", message: "طول رمز عبور می بایست حداقل ۶ کاراکتر باشد");
    else
      if (await _repository.setCompanyUserPassword(readToken(context), cmp, user, peopid, pass)){
        Navigator.pop(context);
        myAlert(context: context, title: "موفقیت آمیز", message: "اختصاص کاربر و رمز عبور موفقیت آمیز بود", color: Colors.green);
      }      
      else
        myAlert(context: context, title: "خطا", message: "اختصاص کاربر و رمز عبور موفقیت آمیز نبود. لطفا پس از بروز رسانی مجددا سعی نمایید");
    }
    catch(e){
      analyzeError(context, e.toString());
      myAlert(context: context, title: "خطا", message: "$e");
    }
  }
  loadCompanyUserGroup(BuildContext context, int cmpid, int userid) async{
    try {
      _companyUserbloc.value.rows.forEach((element) {
        if (element.id == userid)
          element.showgroups = !element.showgroups;
        else
          element.showgroups = false;
      });
      _companyUserbloc.add(_companyUserbloc.value);
      _companyUserGroupbloc.add(CompanyUserGroupModel(status: Status.loading));
      _companyUserGroupbloc.add(CompanyUserGroupModel(status: Status.loaded, rows: await _repository.loadCompanyUsersGroup(readToken(context),cmpid,userid)));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _companyUserGroupbloc.add(CompanyUserGroupModel(status: Status.error, msg: '$e'));
    }
  }
  setCompanyUserGroup(BuildContext context, CompanyUserGroups obj) async{
    try {
      await _repository.setCompanyUsersGroup(readToken(context),obj);
      _companyUserGroupbloc.value.rows.forEach((element) {
          if (element.id == obj.id)
          element.active = !element.active;
       });
       _companyUserGroupbloc.add(_companyUserGroupbloc.value);
    } catch (e) {
      analyzeError(context, e.toString());
    }
  }

  loadEmployee(BuildContext context, int cmpid) async{
    try {
      _employeebloc.add(EmployeeModel(status: Status.loading));
      _employeebloc.add(EmployeeModel(status: Status.loaded, rows: await _repository.loadEmployee(readToken(context),cmpid)));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _employeebloc.add(EmployeeModel(status: Status.error, msg: '$e'));
    }
 }
  showEmployeeFamily(BuildContext context, int cmpid, int empid){
    _employeebloc.value.rows.forEach((element) {
        if (element.peopid == empid){
          element.showfamily = !element.showfamily;
          if (element.showfamily)
            loadEmpFamily(context, cmpid, empid);
        }
        else 
          element.showfamily = false;
    });
    _employeebloc.add(_employeebloc.value);
  }
  loadEmpFamily(BuildContext context, int cmpid, int empid) async{
    try {
      _empfamilybloc.add(EmpFamilyModel(status: Status.loading));
      _empfamilybloc.add(EmpFamilyModel(status: Status.loaded, rows: await _repository.loadEmpFamily(readToken(context),cmpid,empid)));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _empfamilybloc.add(EmpFamilyModel(status: Status.error, msg: '$e'));
    }
  }

  editEmployee(Employee emp) => _newemployeebloc.add(emp);
  setEmployeeSamat(int val){
    _newemployeebloc.value.semat = val;
    _newemployeebloc.add(_newemployeebloc.value);
  }
  setEmployeeCntType(int val){
    _newemployeebloc.value.cnttype = val;
    _newemployeebloc.add(_newemployeebloc.value);
  }
  setEmployeeKind(int val){
    _newemployeebloc.value.kind = val;
    _newemployeebloc.add(_newemployeebloc.value);
  }
  saveEmployee(BuildContext context, int cmpid, Employee emp) async{
    try{
      showWaiting(context);
      emp.token = readToken(context);
      emp.cmpid = cmpid;
      await _repository.saveEmployee(emp);
      hideWaiting(context);
      Navigator.of(context).pop();
      bool nw = true;
      _employeebloc.value.rows.forEach((element) {
        if (element.peopid == emp.peopid){
          nw = false;
          element.hdate = emp.hdate;
          element.cntbdate = emp.cntbdate;
          element.cntedate = emp.cntedate;
          element.expyear = emp.expyear;
          element.kind = emp.kind;
          element.cnttype = emp.cnttype;
          element.permit = emp.permit;
          element.note = emp.note;
        }
      });      
      if (nw)
        _employeebloc.value.rows.insert(0, emp);
      _employeebloc.add(_employeebloc.value);
      myAlert(context: context, title: 'ذخیره', message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.lightGreen);
    }catch(e){
      hideWaiting(context);
      analyzeError(context, e.toString());
    }
 }
  deleteEmployee(BuildContext context, int cmp, Employee emp){
    confirmMessage(context, 'حذف کارمند', 'آیا مایل به حذف ${emp.name} ${emp.family}  می باشید؟', yesclick: () async{
      try{
        await _repository.delEmployee(readToken(context), cmp, emp.peopid);
        _employeebloc.value.rows.removeWhere((element) => element.peopid == emp.peopid);
        _employeebloc.add(_employeebloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${emp.name} ${emp.family} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }

  editEmpFamily(EmpFamily emp) => _newempFamilybloc.add(emp);
  setEmpFamilyKind(int val){
    _newempFamilybloc.value.kind = val;
    _newempFamilybloc.add(_newempFamilybloc.value);
  }
  saveEmpFamily(BuildContext context, int cmpid, Employee emp, EmpFamily family) async{
    try{
      showWaiting(context);
      family.token = readToken(context);
      family.cmpid = cmpid;
      family.empid = emp.peopid;
      await _repository.saveEmpFamily(family);
      hideWaiting(context);
      Navigator.of(context).pop();
      bool nw = true;
      _empfamilybloc.value.rows.forEach((element) {
        if (element.peopid == family.peopid){
          nw = false;
          element.mdate = family.mdate;
          element.job = family.job;
          element.kind = family.kind;
          element.note = family.note;
        }
      });      
      if (nw)
        _empfamilybloc.value.rows.insert(0, family);
      _empfamilybloc.add(_empfamilybloc.value);
      myAlert(context: context, title: 'ذخیره', message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.lightGreen);
    }catch(e){
      hideWaiting(context);
      analyzeError(context, e.toString());
    }
  }
  deleteEmpFamily(BuildContext context, int cmp, int empid, EmpFamily family){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${family.name} ${family.family}  می باشید؟', yesclick: () async{
      try{
        await _repository.delEmpFamily(readToken(context), cmp, empid, family.peopid);
        _empfamilybloc.value.rows.removeWhere((element) => element.peopid == family.peopid);
        _empfamilybloc.add(_empfamilybloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${family.name} ${family.family} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }

  loadDirector(BuildContext context, int cmpid) async{
    try {
      _directorbloc.add(DirectorModel(status: Status.loading));
      _directorbloc.add(DirectorModel(status: Status.loaded, rows: await _repository.loadDirector(readToken(context),cmpid)));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _directorbloc.add(DirectorModel(status: Status.error, msg: '$e'));
    }
  }
  editDirector(Director drt) => _newdirectorbloc.add(drt);
  setDrtFamilyKind(int val){
    _newdrtFamilybloc.value.kind = val;
    _newdrtFamilybloc.add(_newdrtFamilybloc.value);
  }
  setDirectorSamat(int val){
    _newdirectorbloc.value.semat = val;
    _newdirectorbloc.add(_newdirectorbloc.value);
  }
  setDirectorActive(BuildContext context, bool val, int cmpid, Director drt){
    try{
      drt.token = readToken(context);
      drt.cmpid = cmpid;
      _directorbloc.value.rows.forEach((element) async {
        if (element.peopid == drt.peopid){
          element.active = await _repository.setDirectorActive(drt);
          _directorbloc.add(_directorbloc.value);
        }
      });
    }
    catch(e){
      analyzeError(context, e.toString());
    }
  }
  setDirectorSignRight(BuildContext context, bool val, int cmpid, Director drt){
    try{
      drt.token = readToken(context);
      drt.cmpid = cmpid;
      _directorbloc.value.rows.forEach((element) async {
        if (element.peopid == drt.peopid){
          element.signright = await _repository.setDirectorSignRight(drt);
          _directorbloc.add(_directorbloc.value);
        }
      });
    }
    catch(e){
      analyzeError(context, e.toString());
    }
  }
  saveDirector(BuildContext context, int cmpid, Director drt) async{
    try{
      showWaiting(context);
      drt.token = readToken(context);
      drt.cmpid = cmpid;
      await _repository.saveDirector(drt);
      hideWaiting(context);
      Navigator.of(context).pop();
      bool nw = true;
      _directorbloc.value.rows.forEach((element) {
        if (element.peopid == drt.peopid){
          nw = false;
          element.begindate = drt.begindate;
          element.etebardate = drt.etebardate;
          element.etebarno = drt.etebarno;
          element.semat = drt.semat;
        }
      });      
      if (nw)
        _directorbloc.value.rows.insert(0, drt);
      _directorbloc.add(_directorbloc.value);
      myAlert(context: context, title: 'ذخیره', message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.lightGreen);
    }catch(e){
      hideWaiting(context);
      analyzeError(context, e.toString());
    }
  }
  deleteDirector(BuildContext context, int cmp, Director drt){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${drt.name} ${drt.family}  می باشید؟', yesclick: () async{
      try{
        await _repository.delDirector(readToken(context), cmp, drt.peopid);
        _directorbloc.value.rows.removeWhere((element) => element.peopid == drt.peopid);
        _directorbloc.add(_directorbloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${drt.name} ${drt.family} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
  showDirectorFamily(BuildContext context, int cmpid, int drtid){
    _directorbloc.value.rows.forEach((element) {
        if (element.peopid == drtid){
          element.showfamily = !element.showfamily;
          if (element.showfamily)
            loadDrtFamily(context, cmpid, drtid);
        }
        else 
          element.showfamily = false;
    });
    _directorbloc.add(_directorbloc.value);
  }
  loadDrtFamily(BuildContext context, int cmpid, int drtid) async{
    try {
      _drtfamilybloc.add(DrtFamilyModel(status: Status.loading));
      _drtfamilybloc.add(DrtFamilyModel(status: Status.loaded, rows: await _repository.loadDrtFamily(readToken(context),cmpid,drtid)));
    } catch (e) {
      analyzeError(context, e.toString(), msg: false);
      _drtfamilybloc.add(DrtFamilyModel(status: Status.error, msg: '$e'));
    }
  }
  editDrtFamily(DrtFamily drt) => _newdrtFamilybloc.add(drt);
  saveDrtFamily(BuildContext context, int cmpid, Director drt, DrtFamily family) async{
    try{
      showWaiting(context);
      family.token = readToken(context);
      family.cmpid = cmpid;
      family.drtid = drt.peopid;
      await _repository.saveDrtFamily(family);
      hideWaiting(context);
      Navigator.of(context).pop();
      bool nw = true;
      _drtfamilybloc.value.rows.forEach((element) {
        if (element.peopid == family.peopid){
          nw = false;
          element.mdate = family.mdate;
          element.job = family.job;
          element.kind = family.kind;
          element.note = family.note;
        }
      });      
      if (nw)
        _drtfamilybloc.value.rows.insert(0, family);
      _drtfamilybloc.add(_drtfamilybloc.value);
      myAlert(context: context, title: 'ذخیره', message: "ذخیره اطلاعات با موفقیت انجام گردید", color: Colors.lightGreen);
    }catch(e){
      hideWaiting(context);
      analyzeError(context, e.toString());
    }
  }
  deleteDrtFamily(BuildContext context, int cmp, int empid, DrtFamily family){
    confirmMessage(context, 'حذف ', 'آیا مایل به حذف ${family.name} ${family.family}  می باشید؟', yesclick: () async{
      try{
        await _repository.delDrtFamily(readToken(context), cmp, empid, family.peopid);
        _drtfamilybloc.value.rows.removeWhere((element) => element.peopid == family.peopid);
        _drtfamilybloc.add(_drtfamilybloc.value);
        myAlert(context: context, title: 'حذف', message: 'حذف ${family.name} ${family.family} با موفقیت انجام گردید', color: Colors.green);
      }catch(e){
        analyzeError(context, e.toString());
      }
      Navigator.pop(context);
    });
  }
}