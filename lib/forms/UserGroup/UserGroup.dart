import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import 'UserGroupBloc.dart';

class FmUserGroup extends StatelessWidget {
  const FmUserGroup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserGroupBloc _usergroupBloc = UserGroupBloc()..loadData(context);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Column(
        children: [
          FormHeader(
            title: 'گروه های کاربری', 
            btnRight: MyIconButton(type: ButtonType.add, onPressed: () => _usergroupBloc.newgroup()), 
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed: () => _usergroupBloc.loadData(context))
          ),
          Expanded(
            child: StreamBuilder(
              stream: _usergroupBloc.usergroupStream$,
              builder: (BuildContext context, AsyncSnapshot<UserGroupModel> snapshot){
                if (snapshot.hasData)
                  if (snapshot.data.status == Status.error)
                    return ErrorInGrid(snapshot.data.msg);
                  else if (snapshot.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snapshot.data.rows.length,
                      itemBuilder: (context, idx){
                        UserGroup _grp = snapshot.data.rows[idx];
                        return Card(
                          color: idx.isOdd && !_grp.permission && !_grp.users ? appbarColor(context) : Colors.transparent,
                          child: _grp.permission 
                            ? Container(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(color: accentcolor(context).withOpacity(0.3), child: UserGroupRow(usergroupBloc: _usergroupBloc, grp: _grp)),
                                  GridTextField(hint: '... جستجو', width: 250.0, onChange: (val) => _usergroupBloc.searchInPermission(val),),
                                  SizedBox(height: 15),
                                  StreamBuilder(
                                    stream: _usergroupBloc.groupPermissionStream$,
                                    builder: (BuildContext context, AsyncSnapshot<GroupPermissionModel> snapshot){
                                      if (snapshot.hasData){
                                        if (snapshot.data.status == Status.error)
                                          return ErrorInGrid(snapshot.data.msg);
                                        else if (snapshot.data.status == Status.loaded)
                                          return Wrap(
                                            children: snapshot.data.rows.map((e) => e.insearch ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              child: Container(
                                                margin: EdgeInsets.all(5.0),
                                                child: PermissionChip(
                                                  selected: e.valid,
                                                  title: e.title, 
                                                  onSelected: (val)=>_usergroupBloc.setGroupPermission(context, _grp.id, e.id)
                                                ),
                                              )
                                            ) : Container(width: 0,)).toList(),
                                          );
                                      }
                                      return Center(child: CupertinoActivityIndicator());
                                    }
                                  ),
                                  SizedBox(height: 25),
                                ],
                              ),
                            )
                            : _grp.users
                              ? Container(
                                height: 500.0,
                                child: Column(
                                  children: [
                                    Card(color: accentcolor(context).withOpacity(0.3), child: UserGroupRow(usergroupBloc: _usergroupBloc, grp: _grp)),
                                    GridCaption(
                                      obj: [
                                        MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: NewUser(usergroupbloc: _usergroupBloc, grp: _grp))),
                                        'عنوان اتحادیه','','نام و نام خانوادگی','','شماره همراه','نام کاربری','آخرین ورود',
                                      ],
                                    ),
                                    GridTextField(hint: '... جستجو', onChange: (val) => _usergroupBloc.searchInUsers(val),),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: StreamBuilder(
                                          stream: _usergroupBloc.groupUserStream$,
                                          builder: (BuildContext context, AsyncSnapshot<GroupUserModel> snapshot){
                                            if (snapshot.hasData)
                                              if (snapshot.data.status == Status.error)
                                                return ErrorInGrid(snapshot.data.msg);
                                              else if (snapshot.data.status == Status.loaded)
                                                return ListView.builder(
                                                  itemCount: snapshot.data.rows.length,
                                                  itemBuilder: (BuildContext context, int idx){
                                                    GroupUser _user = snapshot.data.rows[idx];
                                                    return _user.insearch 
                                                      ? Card(
                                                        color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=${_user.userid}"),),
                                                            SizedBox(width: 10.0,),
                                                            Expanded(flex: 2, child: Text(_user.cmpname)),
                                                            !_user.active ? Tooltip(message: 'کاربر غیرفعال می باشد', child: Icon(CupertinoIcons.person_badge_minus, color: Colors.redAccent[100],)) : Container(),
                                                            Expanded(flex: 2, child: Text(_user.family)),
                                                            Expanded(child: Text(_user.mobile)),
                                                            Expanded(child: Text(_user.username)),
                                                            Expanded(child: Text(_user.lastLogin)),
                                                            MyIconButton(type: ButtonType.del, onPressed: () => _usergroupBloc.delUserFromGroup(context, _grp.name, _user))
                                                          ],
                                                        ),
                                                      )
                                                      : Container();
                                                  }
                                                );
                                            return Center(child: CupertinoActivityIndicator());
                                          }
                                        ),
                                      )
                                    )
                                  ],  
                                ),
                              )
                              : UserGroupRow(usergroupBloc: _usergroupBloc, grp: _grp)
                        );
                      }
                    );
                return Center(child: CupertinoActivityIndicator(),);
              },
            ),
          ),
        ],
      )
    );
  }
}

class UserGroupRow extends StatelessWidget {
  const UserGroupRow({Key key,@required this.usergroupBloc,@required this.grp}) : super(key: key);

  final UserGroupBloc usergroupBloc;
  final UserGroup grp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => usergroupBloc.changeMode(context, grp.id, edit: true),
      child: Row(
        children: [
          SizedBox(width: 5.0,),
          Expanded(child: grp.edit 
            ? GridTextField(hint: 'عنوان گروه', initialValue: grp.name, onChange: (val) => grp.name=val, autofocus: true) 
            : Text('${grp.name}')),
          !grp.edit ? MyIconButton(type: ButtonType.other, hint: 'مجوزها', icon: Icon(CupertinoIcons.lock_shield), onPressed: () => usergroupBloc.changeMode(context, grp.id, permission: true)) : Container(),
          !grp.edit ? MyIconButton(type: ButtonType.other, hint: 'کاربران', icon: Icon(CupertinoIcons.person_3), onPressed: () => usergroupBloc.changeMode(context, grp.id, users: true)) : Container(),
          grp.edit
            ? MyIconButton(type: ButtonType.save, onPressed: () => usergroupBloc.save(context, grp))
            : MyIconButton(type: ButtonType.del, onPressed: () => usergroupBloc.delete(context, grp)),
        ],
      ),
    );
  }
}

class NewUser extends StatelessWidget {
  const NewUser({Key key, @required this.usergroupbloc, @required this.grp}) : super(key: key);

  final UserGroupBloc usergroupbloc;
  final UserGroup grp;

  @override
  Widget build(BuildContext context) {
    usergroupbloc.newuser(context, grp.id);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenHeight(context) * 0.75,
        child: Column(
          children: [
            FormHeader(title: 'کاربران گروه کاربری ${grp.name}', btnLeft: MyIconButton(type: ButtonType.exit, onPressed: (){usergroupbloc.loadUser(context, grp.id); Navigator.pop(context);})),
            GridTextField(hint: '... جستجو', onChange: (val) => usergroupbloc.searchNewUser(val),),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: usergroupbloc.newUserStream$,
                  builder: (BuildContext context, AsyncSnapshot<GroupUserModel> snapshot){
                    if (snapshot.hasData)
                      if (snapshot.data.status == Status.error)
                        return ErrorInGrid(snapshot.data.msg);
                      else if (snapshot.data.status == Status.loaded)
                        return Wrap(
                          children: snapshot.data.rows.map((e) => e.insearch ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            width: 225, 
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: e.valid ? Colors.green : Colors.grey,
                                  child: CircleAvatar(
                                    radius: 26,
                                    backgroundImage: NetworkImage("http://${serverIP()}:8080/PamaApi/LoadFile.jsp?type=user&id=${e.userid}"),
                                  )
                                ),
                                trailing: !e.active ? Tooltip(message: 'کاربر غیرفعال می باشد', child: Icon(CupertinoIcons.person_badge_minus, color: Colors.redAccent[100])) : null,
                                selected: e.valid,
                                title: Text(e.family), 
                                subtitle: Text(e.cmpname), 
                                isThreeLine: true, 
                                onTap: () => usergroupbloc.assignUserToGroup(context, grp.id, e),
                              )
                            )
                          ) : Container(width: 0,)).toList(),
                        );
                    return Center(child: CupertinoActivityIndicator(),);
                  }
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}



