import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../AddInfo/AddInfoData.dart';
import '../Attach/Attach.dart';
import '../People/People.dart';
import 'CompanyBloc.dart';

class FmDirector extends StatelessWidget {
  const FmDirector({Key key, @required this.company, @required this.user, @required this.companybloc}) : super(key: key);

  final Company company;
  final User user;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.8,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            FormHeader(title: 'اعضای هیئت رئیسه ${company.name}', btnRight: MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: FmPeople(nationalid: "", justcheck: true,), done: (dynamic data){
                if (data is People){
                  if (companybloc.companydirector$.where((element) => element.peopid == data.id).length > 0)
                    myAlert(context: context, title: "توجه", message: "${data.name} ${data.family} قبلا اختصاص داده شده است");
                  else
                    showFormAsDialog(
                      context: context, 
                      form: DirectorEdit(
                        companybloc: this.companybloc, 
                        cmpid: this.company.id, 
                        director:new Director(
                          peopid: data.id,
                          name: data.name,
                          family: data.family,
                          nationalid: data.nationalid,
                          mobile: data.mobile,
                          active: 1,
                          begindate: "",
                          etebardate: "",
                          etebarno: 0,
                          semat: 1,
                          signright: 0,
                          showfamily: false
                        ),
                      )
                    );
                }
              }))
            ),
            GridCaption(obj: ['وضعیت', 'کد ملی', 'نام و نام خانوادگی', 'سمت', 'شماره اعتبارنامه', 'تاریخ اعتبارنامه', 'سابقه عضویت', 'تاریخ شروع','حق امضاء']),
            Expanded(
              child: StreamBuilder(
                stream: companybloc.directorStream$,
                builder: (BuildContext congtext, AsyncSnapshot<DirectorModel> snapshot){
                  if (snapshot.hasData && snapshot.data.status == Status.error)
                    return ErrorInGrid(snapshot.data.msg);
                  if (snapshot.hasData && snapshot.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snapshot.data.rows.length,
                      itemBuilder: (BuildContext context, int idx){
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: snapshot.data.rows[idx].showfamily 
                            ? Container(
                              height: screenHeight(context) * 0.5,
                              child: Column(
                                children: [
                                  Card(color: accentcolor(context).withOpacity(0.5),child: DirectorRow(cmpid: this.company.id, companybloc: this.companybloc,drt: snapshot.data.rows[idx])),
                                  SizedBox(height: 15.0,),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: DirectorFamily(cmpid: this.company.id, companybloc: this.companybloc,drt: snapshot.data.rows[idx], color: idx.isOdd ? scaffoldcolor(context) : appbarColor(context),),
                                    ),
                                  )
                                ],
                              ),
                            ) 
                            : DirectorRow(cmpid: this.company.id, companybloc: this.companybloc,drt: snapshot.data.rows[idx]),
                        );
                      }
                    );
                  return Center(child: CupertinoActivityIndicator(),);
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}

class DirectorRow extends StatelessWidget {
  const DirectorRow({Key key, @required this.companybloc,@required this.cmpid, @required this.drt}) : super(key: key);

  final Director drt;
  final int cmpid;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => showFormAsDialog(context: context, form: DirectorEdit(companybloc: companybloc, cmpid: cmpid, director: drt)),
      child: Row(
        children: [
          PeoplePic(id: drt.peopid,),
          SizedBox(width: 5.0,),
          Switch(value: drt.active==1, onChanged: (val) => companybloc.setDirectorActive(context,val,cmpid, drt)),
          Expanded(child: Text('${drt.nationalid}')),
          Expanded(child: Text('${drt.name} ${drt.family}')),
          Expanded(child: Text('${drt.sematName()}')),
          Expanded(child: Text('${drt.etebarno}')),
          Expanded(child: Text('${drt.etebardate}')),
          Expanded(child: Text('')),
          Expanded(child: Text('${drt.begindate}')),
          Switch(value: drt.signright==1, onChanged: (val) => companybloc.setDirectorSignRight(context,val,cmpid, drt)),
          PopupMenuButton(
            tooltip: 'تنظیمات',
            itemBuilder: (_) => <PopupMenuItem<int>>[
              myPopupMenuItem(icon: Icons.delete, title: 'حذف', value: 1),
              myPopupMenuItem(icon: Icons.people, title: 'اعضای خانواده', value: 2),
              myPopupMenuItem(icon: Icons.people, title: 'اطلاعات تکمیلی', value: 3),
              myPopupMenuItem(icon: Icons.attach_file, title: 'بارگذاری فایل', value: 4),
            ],
            onSelected: (int menu){
              if (menu == 1)
                companybloc.deleteDirector(context, cmpid, drt);
              if (menu == 2)
                companybloc.showDirectorFamily(context, cmpid, drt.peopid);
              if (menu == 3)
                showFormAsDialog(context: context, form: FmAddInfoData(url: 'Company/Director/AddInfo', title: 'اطلاعات تکمیلی عضو هییت رییسه ${drt.name} ${drt.family}', header: {'cmpid': cmpid.toString(), 'peopid': drt.peopid.toString()}));
              if (menu ==4 )
                showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${drt.name} ${drt.family}', tag: 'CmpDirectorMng', cmpid: cmpid, id1: drt.peopid));
            }
          )
        ],
      ),
    );
  }
}

class DirectorFamily extends StatelessWidget {

  const DirectorFamily({Key key, @required this.companybloc,@required this.cmpid, @required this.drt, @required this.color}) : super(key: key);

  final Director drt;
  final int cmpid;
  final CompanyBloc companybloc;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridCaption(
          obj: [
            MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: FmPeople(nationalid: "", justcheck: true,), done: (dynamic data){
              if (data is People){
                if (companybloc.companydrtFamily$.where((element) => element.peopid == data.id).length > 0)
                  myAlert(context: context, title: "توجه", message: "${data.name} ${data.family} قبلا اختصاص داده شده است");
                else
                  showFormAsDialog(
                    context: context, 
                    form: DirectorFamilyEdit(
                      companybloc: this.companybloc, 
                      cmpid: this.cmpid, 
                      drt: this.drt,
                      family:new DrtFamily(
                        peopid: data.id,
                        name: data.name,
                        family: data.family,
                        father: data.father,
                        ss: data.ss,
                        ssplace: data.ssplace,
                        birth: data.birth,
                        birthdate: data.birthdate,
                        nationalid: data.nationalid,
                        reshte: data.reshte,
                        education: data.education,
                        isargari: data.isargari,
                        note: "",
                        job: "",
                        kind: 1,
                        mdate: "",
                      ),
                    )
                  );
              }
            })),
            'کد ملی','نام و نام خانوادگی','نسبت','میزان تحصیلات','رشته تحصیلی','تاریخ ازدواج','ایثارگری', 
            MyIconButton(type: ButtonType.exit, onPressed: ()=>companybloc.showDirectorFamily(context, cmpid, drt.peopid)),
          ], endbuttons: 0,
        ),
        Expanded(
          child: StreamBuilder(
            stream: companybloc.drtfamilyStream$,
            builder: (BuildContext congtext, AsyncSnapshot<DrtFamilyModel> snapshot){
              if (snapshot.hasData && snapshot.data.status == Status.error)
                return ErrorInGrid(snapshot.data.msg);
              if (snapshot.hasData && snapshot.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snapshot.data.rows.length,
                  itemBuilder: (BuildContext context, int idx){
                    return Card(
                      color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                      child: GestureDetector(
                        onDoubleTap: ()=>showFormAsDialog(context: context, form: DirectorFamilyEdit(companybloc: companybloc, cmpid: cmpid, drt: drt, family: snapshot.data.rows[idx])),
                        child: Row(
                          children: [
                            PeoplePic(id: snapshot.data.rows[idx].peopid,),
                            SizedBox(width: 5.0,),
                            Expanded(child: Text('${snapshot.data.rows[idx].nationalid}')),
                            Expanded(child: Text('${snapshot.data.rows[idx].name} ${snapshot.data.rows[idx].family}')),
                            Expanded(child: Text('${snapshot.data.rows[idx].kindName()}')),
                            Expanded(child: Text('${snapshot.data.rows[idx].educationName()}')),
                            Expanded(child: Text('${snapshot.data.rows[idx].reshte}')),
                            Expanded(child: Text('${snapshot.data.rows[idx].mdate}')),
                            Expanded(child: Text('${snapshot.data.rows[idx].isargariName()}')),
                            MyIconButton(type: ButtonType.del, onPressed: ()=>companybloc.deleteDrtFamily(context, cmpid, drt.peopid, snapshot.data.rows[idx]))
                          ],
                        ),
                      ),
                    );
                  }
                );
              return Center(child: CupertinoActivityIndicator(),);
            }
          ),
        ),
      ],
    );
  }
}

class DirectorEdit extends StatelessWidget {
  const DirectorEdit({Key key, @required this.companybloc, @required this.cmpid, @required this.director}) : super(key: key);

  final int cmpid;
  final Director director;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {

    TextEditingController _begindate = TextEditingController(text: director.begindate);
    TextEditingController _etebardate = TextEditingController(text: director.etebardate);
    companybloc.editDirector(director);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: companybloc.newdirectorStream$,
        builder: (BuildContext context, AsyncSnapshot<Director> snap){
          if (!snap.hasData)
            return Center(child: CupertinoActivityIndicator(),);
          Director drt = snap.data;
          return Container(
            width: screenWidth(context) * 0.4,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(title: 'ویرایش اطلاعات اعضای هیئت رئیسه', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){
                  drt.begindate = _begindate.text;
                  drt.etebardate = _etebardate.text;
                  companybloc.saveDirector(context, cmpid, drt);
                })),
                MyRow(
                  children: [
                    'کد ملی', 
                    drt.nationalid,
                    MyIconButton(type: ButtonType.info, hint: 'اطلاعات فردی', onPressed: () => showFormAsDialog(context: context, form: FmPeople(justcheck: false, nationalid: drt.nationalid,))),
                  ]
                ),
                MyRow(children: ['نام و نام خانوادگی', '${drt.name} ${drt.family}']),
                MyRow(children: ['شماره همراه', drt.mobile]),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'شماره اعتبارنامه', initialValue: drt.etebarno.toString(), onChange: (val){drt.etebarno = int.parse(val);}, autofocus: true,)),
                    Expanded(child: GridTextField(hint: 'تاریخ اعتبارنامه', controller: _etebardate, datepicker: true,)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MultiChooseItem(
                        hint: 'سمت',
                        val: drt.semat, 
                        items: [
                          {'id': 1, 'title': 'رئیس'},
                          {'id': 2, 'title': 'نایب رئیس اول'},
                          {'id': 3, 'title': 'نایب رئیس دوم'},
                          {'id': 4, 'title': 'عضو'},
                          {'id': 5, 'title': 'خزانه دار'},
                          {'id': 6, 'title': 'بازرس'},
                          {'id': 7, 'title': 'دبیر'},
                        ],
                        onChange: (val){companybloc.setDirectorSamat(val);},
                      )
                    ),
                    Expanded(child: GridTextField(hint: 'تاریخ شروع بکار', controller: _begindate, datepicker: true, notempty: true)),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class DirectorFamilyEdit extends StatelessWidget {
  const DirectorFamilyEdit({Key key, @required this.companybloc, @required this.cmpid, @required this.drt, @required this.family}) : super(key: key);

  final int cmpid;
  final Director drt;
  final DrtFamily family;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {

    TextEditingController _mdate = TextEditingController(text: family.mdate);
    companybloc.editDrtFamily(family);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: companybloc.newdrtFamilyStream$,
        builder: (BuildContext context, AsyncSnapshot<DrtFamily> snap){
          if (!snap.hasData)
            return Center(child: CupertinoActivityIndicator(),);
          DrtFamily family = snap.data;
          return Container(
            width: screenWidth(context) * 0.4,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(title: 'تعریف/ویرایش اعضای خانواده همکار محترم ${family.name} ${family.family}', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){family.mdate = _mdate.text; companybloc.saveDrtFamily(context, cmpid, drt, family);})),
                MyRow(
                  children: [
                    'کد ملی', 
                    family.nationalid,
                    MyIconButton(type: ButtonType.info, hint: 'اطلاعات فردی', onPressed: () => showFormAsDialog(context: context, form: FmPeople(justcheck: false, nationalid: family.nationalid,))),
                  ]
                ),
                MyRow(children: ['نام و نام خانوادگی', '${family.name} ${family.family}']),
                MyRow(children: ['نام پدر', family.father]),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(
                      child: MultiChooseItem(
                        hint: 'نسبت',
                        val: family.kind ?? 1, 
                        items: [
                          {'id': 1, 'title': 'پدر'},
                          {'id': 2, 'title': 'مادر'},
                          {'id': 3, 'title': 'برادر'},
                          {'id': 4, 'title': 'خواهر'},
                          {'id': 5, 'title': 'همسر'},
                          {'id': 6, 'title': 'فرزند'},
                        ],
                        onChange: (val) => companybloc.setDrtFamilyKind(val),
                      ),
                    ),
                    Expanded(child: (family.single ?? 2) == 2 ? GridTextField(hint: 'تاریخ ازدواج', controller: _mdate, datepicker: true, autofocus: true, notempty: true) : Container()),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: GridTextField(hint: 'شغل', initialValue: family.job ?? "", onChange: (val){family.job = val;})),
                    Expanded(child: GridTextField(hint: 'توضیحات', initialValue: family.note ?? "", onChange: (val){family.note = val;})),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}





