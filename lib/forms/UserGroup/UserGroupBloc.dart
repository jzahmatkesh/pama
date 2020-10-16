import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../classes/Repository.dart';
import '../../classes/classes.dart';
import '../../module/functions.dart';


class UserGroupModel{
  Status status;
  List<UserGroup> rows;
  String msg;

  UserGroupModel({@required this.status, this.rows, this.msg});
}
class GroupPermissionModel{
  Status status;
  List<GroupPermission> rows;
  String msg;

  GroupPermissionModel({@required this.status, this.rows, this.msg});
}
class GroupUserModel{
  Status status;
  List<GroupUser> rows;
  String msg;

  GroupUserModel({@required this.status, this.rows, this.msg});
}

class UserGroupBloc{
  UserGroupRepository _repository = UserGroupRepository();

  BehaviorSubject<UserGroupModel> _usergroupBloc = BehaviorSubject<UserGroupModel>.seeded(UserGroupModel(status: Status.loading));
  Stream<UserGroupModel> get usergroupStream$ => _usergroupBloc.stream;

  BehaviorSubject<GroupPermissionModel> _groupPermissionBloc = BehaviorSubject<GroupPermissionModel>.seeded(GroupPermissionModel(status: Status.loading));
  Stream<GroupPermissionModel> get groupPermissionStream$ => _groupPermissionBloc.stream;

  BehaviorSubject<GroupUserModel> _groupUserBloc = BehaviorSubject<GroupUserModel>.seeded(GroupUserModel(status: Status.loading));
  Stream<GroupUserModel> get groupUserStream$ => _groupUserBloc.stream;

  BehaviorSubject<GroupUserModel> _newUserBloc = BehaviorSubject<GroupUserModel>.seeded(GroupUserModel(status: Status.loading));
  Stream<GroupUserModel> get newUserStream$ => _newUserBloc.stream;

  loadData(BuildContext context) async{
    try{
      _usergroupBloc.add(UserGroupModel(status: Status.loading));
      _usergroupBloc.add(UserGroupModel(status: Status.loaded, rows: await _repository.load(readToken(context))));
    }
    catch(e){
      analyzeError(context, '$e');
      _usergroupBloc.add(UserGroupModel(status: Status.error, msg: '$e'));
    }
  }

  save(BuildContext context, UserGroup grp) async{
    if (grp.name.isEmpty)
      myAlert(context: context, title: 'خطا', message: "عنوان گروه مشخص نشده است");
    else
    try{
      showWaiting(context);
      grp.token = readToken(context);
      int _id = await _repository.save(grp);
      bool valid = false;
      _usergroupBloc.value.rows.forEach((element) {
        if (element.id == grp.id){
          valid = true;
          element.id = _id;
          element.name = grp.name;
          element.edit = false;
        }
      });
      if (!valid)
        _usergroupBloc.value.rows.insert(0, UserGroup(id: _id, name: grp.name));
      _usergroupBloc.add(_usergroupBloc.value);
      hideWaiting(context);
    }
    catch(e){
      hideWaiting(context);
      analyzeError(context, '$e');
    }
  }

  delete(BuildContext context, UserGroup grp){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف گروه ${grp.name} می باشید؟', yesclick: () async{
      try{
        showWaiting(context);
        grp.token = readToken(context);
        await _repository.delete(grp);
        _usergroupBloc.value.rows.removeWhere((element) => element.id == grp.id);
        _usergroupBloc.add(_usergroupBloc.value);
        hideWaiting(context);
      }
      catch(e){
        hideWaiting(context);
        analyzeError(context, '$e');
      }
      Navigator.pop(context);
    });
  }

  changeMode(BuildContext context, int id,{bool edit=false,bool permission=false, bool users=false}){
    _usergroupBloc.value.rows.forEach((element) {
      if (element.id == id && edit)
        element.edit = !element.edit;
      else
        element.edit = false;
      if (element.id == id && permission)
        element.permission = !element.permission;
      else
        element.permission = false;
      if (element.id == id && users)
        element.users = !element.users;
      else
        element.users = false;

      if (element.permission)
        loadPermission(context, id);
      if (element.users)
        loadUser(context, id);
    });
    _usergroupBloc.add(_usergroupBloc.value);
  }

  newgroup(){
    bool can = true;
    _usergroupBloc.value.rows.forEach((element) {
      if (element.id == 0)
        can = false;
    });
    if (can){
      _usergroupBloc.value.rows.insert(0, UserGroup(id: 0, name: '', edit: true));
      _usergroupBloc.add(_usergroupBloc.value);
    }
  }

  loadPermission(BuildContext context, int id) async{
    try{
      _groupPermissionBloc.add(GroupPermissionModel(status: Status.loading));
      _groupPermissionBloc.add(GroupPermissionModel(status: Status.loaded, rows: await _repository.loadPermission(readToken(context), id) ));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _groupPermissionBloc.add(GroupPermissionModel(status: Status.error, msg: '$e'));
    }
  }

  setGroupPermission(BuildContext context, int grpid, int prvid) async{
    try{
      bool res = await _repository.setGroupPermission(GroupPermission(token: readToken(context), grpid: grpid, id: prvid));
      _groupPermissionBloc.value.rows.forEach((element) {
        if (element.id == prvid)
          element.valid = res;
      });
      _groupPermissionBloc.add(_groupPermissionBloc.value);
    }
    catch(e){
      analyzeError(context, '$e');
    }
  }

  searchInPermission(String str){
    _groupPermissionBloc.value.rows.forEach((element) {
      element.insearch = element.title.contains(str);
    });
    _groupPermissionBloc.add(_groupPermissionBloc.value);
  }

  loadUser(BuildContext context, int id) async{
    try{
      _groupUserBloc.add(GroupUserModel(status: Status.loading));
      _groupUserBloc.add(GroupUserModel(status: Status.loaded, rows: await _repository.loadusers(readToken(context), id) ));
    }
    catch(e){
      analyzeError(context, '$e', msg: false);
      _groupUserBloc.add(GroupUserModel(status: Status.error, msg: '$e'));
    }
  }

  searchInUsers(String str){
     _groupUserBloc.value.rows.forEach((element) {
      element.insearch = element.family.contains(str) || element.cmpname.contains(str) || element.mobile.contains(str) || element.username.contains(str);
    });
    _groupUserBloc.add(_groupUserBloc.value);
  }

  delUserFromGroup(BuildContext context, String grpname, GroupUser user){
    confirmMessage(context, 'تایید حذف', 'آیا مایل به حذف کاربر ${user.family} از گروه $grpname می باشید؟', yesclick: ()async{
      try{
        CompanyRepository _cmprep = CompanyRepository();
        await _cmprep.setCompanyUsersGroup(readToken(context), CompanyUserGroups(userid: user.userid, id: user.grpid, active: true));
        _groupUserBloc.value.rows.removeWhere((element) => element.userid==user.userid);
        _groupUserBloc.add(_groupUserBloc.value);
        Navigator.pop(context);
      }
      catch(e){
        analyzeError(context, '$e');
      }
    });
  }

  newuser(BuildContext context, int grpid) async{
    try{
      _newUserBloc.add(GroupUserModel(status: Status.loading));
      _newUserBloc.add(GroupUserModel(status: Status.loaded, rows: await _repository.newusers(readToken(context), grpid)));
    }
    catch(e){
      analyzeError(context, '$e');
      _newUserBloc.add(GroupUserModel(status: Status.error, msg: '$e'));     
    }
  }
  searchNewUser(String str){
    _newUserBloc.value.rows.forEach((element) {
      element.insearch = element.family.contains(str) || element.cmpname.contains(str);
    });
    _newUserBloc.add(_newUserBloc.value);
  }

  assignUserToGroup(BuildContext context, int grpid, GroupUser user) async{
      try{
        CompanyRepository _cmprep = CompanyRepository();
        await _cmprep.setCompanyUsersGroup(readToken(context), CompanyUserGroups(userid: user.userid, id: grpid, active: user.valid));
        _newUserBloc.value.rows.forEach((element) {
          if (element.userid == user.userid)
            element.valid = !element.valid;
        });
        _newUserBloc.add(_newUserBloc.value);
      }
      catch(e){
        analyzeError(context, '$e');
      }
  }
}