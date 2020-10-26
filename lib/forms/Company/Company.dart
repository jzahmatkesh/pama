import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/forms/NoLicense/NoLicense.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../AddInfo/AddInfoData.dart';
import '../Committee/Committee.dart';
import '../Inspection/Inspection.dart';
import '../People/People.dart';
import '../Property/Property.dart';
import '../Raste/RasteBloc.dart';
import 'CompanyBloc.dart';
import 'Director.dart';
import 'Employee.dart';

class FmCompany extends StatelessWidget {
  const FmCompany({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    CompanyBloc _companyBloc = CompanyBloc()..loadCompany(context);

    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          FormHeader(
            title: 'لیست اتحادیه ها و اتاق اصناف مشهد', 
            btnRight: MyIconButton(type: ButtonType.add, hint: 'تعریف اتحادیه جدید', onPressed: ()=>showFormAsDialog(context: context, form: EditCompany(user: this.user, company: Company(id: 0), companybloc: _companyBloc))), 
            btnLeft: MyIconButton(type: ButtonType.reload, onPressed: ()=>_companyBloc.loadCompany(context))
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal:25),
            height: 75,
            child: GridTextField(hint: 'جستجو بر اساس نام / تلفن / آدرس', onChange: (val) => _companyBloc.searchByName(val),),
          ),
          Expanded(
            child: GridCompanyList(companyBloc: _companyBloc, user: user),
          ),
        ],
      ),
    );
  }
}

class CompanyRow extends StatelessWidget {
  const CompanyRow({
    Key key,
    @required this.companyBloc,
    @required this.user,
    @required this.company,
    @required this.dashboardicon
  }) : super(key: key);

  final CompanyBloc companyBloc;
  final Company company;
  final User user;
  final bool dashboardicon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: ()=>showFormAsDialog(context: context, form: EditCompany(user: this.user, company: this.company, companybloc: this.companyBloc)),
      child: Row(
        children: [
          this.company.id==1
            ? CircleAvatar(
              radius: 22,
              backgroundColor: accentcolor(context),
              child: CompanyPic(id: this.company.id),
            )
            : CompanyPic(id: this.company.id),
          Switch(value: this.company.active==1, onChanged: (val){
            companyBloc.setActive(context, this.company.id);
          }),
          SizedBox(width: 5,),
          this.company.id == 1 ? Icon(CupertinoIcons.timelapse, color: Colors.yellow,) : Container(),
          Expanded(flex: 2, child: Text("${this.company.name}")),
          SizedBox(width: 5,),
          Expanded(child: Text(this.company.nationalid.toString())),
          SizedBox(width: 5,),
          Expanded(child: Text(this.company.tel)),
          SizedBox(width: 5,),
          Expanded(flex: 3, child: Text('${this.company.address}')),
          SizedBox(width: 5,),
          dashboardicon ? IconButton(tooltip: 'داشبرد', icon: Icon(Icons.dashboard_outlined), onPressed: ()=>companyBloc.showcompanyInfo(this.company.id)) : Container()
        ],
      ),
    );
  }
}

class GridCompanyList extends StatelessWidget {
  const GridCompanyList({
    Key key,
    @required this.companyBloc,
    @required this.user,
  }): super(key: key);

  final CompanyBloc companyBloc;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridCaption(obj: ['','عنوان','', 'شناسه ملی', 'تلفن', 'آدرس', '', '']),
        Expanded(
          child: StreamBuilder(
            stream: companyBloc.companyListStream$,
            builder: (BuildContext context, AsyncSnapshot<CompanyModel> snapshot){
              if (snapshot.hasData && snapshot.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snapshot.data.rows.length,
                  itemBuilder: (BuildContext context, int index) {
                    Company _company = snapshot.data.rows[index];
                    if (!snapshot.data.rows[index].insearchquery)
                      return Container();
                    return Card(
                      color: index.isOdd && !snapshot.data.rows[index].showinfo ? appbarColor(context) : Colors.transparent,
                      child: snapshot.data.rows[index].showinfo || snapshot.data.rows.length == 1
                        ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              color: accentcolor(context).withOpacity(0.3),
                              child: CompanyRow(companyBloc: companyBloc, user: user, company: _company, dashboardicon: snapshot.data.rows.length>1,)
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 25.0),
                              child: Wrap(
                                children: [
                                  DesktopIcon(title: 'کاربران سیستم', subtitle: 'کاربران ${_company.cntuser} رکورد', icon: Icon(Icons.supervised_user_circle), onPressed: (){companyBloc.loadCompanyUser(context, _company.id); showFormAsDialog(context: context, form: FmCompanyUsers(user: this.user, company: _company, companybloc: this.companyBloc), modal: true);}),
                                  DesktopIcon(title: 'کارکنان و مشاوران', subtitle: 'کارمندان ${_company.cntemp} رکورد', icon: Icon(Icons.people), onPressed: (){companyBloc.loadEmployee(context, _company.id); showFormAsDialog(context: context, form: FmEmployee(user: this.user, company: _company, companybloc: this.companyBloc), modal: true);}),
                                  DesktopIcon(title: 'اعضای هیت رییسه', subtitle: 'اعضا ${_company.cntdrt} نفر', icon: Icon(Icons.supervised_user_circle_rounded), onPressed: (){companyBloc.loadDirector(context, _company.id); showFormAsDialog(context: context, form: FmDirector(user: this.user, company: _company, companybloc: this.companyBloc), modal: true);}),
                                  DesktopIcon(title: 'اطلاعات تکمیلی', subtitle: 'اطلاعات تعریف شده ${_company.cntaddinfo} رکورد', icon: Icon(Icons.list), onPressed: () => showFormAsDialog(context: context, form: FmAddInfoData(title: 'اطلاعات تکمیلی ${snapshot.data.rows[index].name}', url: 'Company/AddInfo', header: {'cmpid': snapshot.data.rows[index].id.toString()}))),
                                  DesktopIcon(title: 'کمیسیون و جلسات', subtitle: 'کمیسیون و جلسات ${_company.cntcom} رکورد', icon: Icon(Icons.meeting_room_rounded), 
                                    onPressed: (){
                                      if(_company.cntemp == 0) 
                                        myAlert(context: context, title: 'خطا', message: 'کارکنان و مشاوران تعریف نشده است', color: Colors.deepOrange);
                                      else
                                        showFormAsDialog(context: context, form: FmCommittee(company: _company));
                                    }
                                  ),
                                  DesktopIcon(title: 'فایلهای ضمیمه', subtitle: 'فایلهای ضمیمه شده ${_company.cntattach} فایل', icon: Icon(Icons.attach_file), onPressed: (){}),
                                  _company.id > 1 ? DesktopIcon(title: 'آیین نامه', subtitle: 'آیین نامه تحادیه', icon: Icon(CupertinoIcons.rectangle_on_rectangle_angled), onPressed: () => showFormAsDialog(context: context, form: CompanybyLaw(companyBloc: companyBloc, cmp: _company))): Container(width: 0),
                                  DesktopIcon(title: 'اموال منقول/غیر منقول', subtitle: 'اموال ${_company.cntproperty} رکورد', icon: Icon(Icons.web_asset), onPressed: () => showFormAsDialog(context: context, form: FmProperty(cmp: _company))),
                                  DesktopIcon(title: 'طرح های بازرسی و نظارت',  subtitle: 'طرح های بازرسی ${_company.cntbzr} رکورد', icon: Icon(Icons.security), onPressed: () => showFormAsDialog(context: context, form: FmInspection(company: _company))),
                                  DesktopIcon(title: 'فاقدین پروانه شناسایی شده',  subtitle: 'افراد شناسایی شده ${_company.cntlcn} نفر', icon: Icon(CupertinoIcons.person_crop_circle_fill_badge_exclam), onPressed: () => showFormAsDialog(context: context, form: FmNoLicense(cmpid: _company.id))),
                                  DesktopIcon(title: 'تنظیم کدینگ درآمد',  subtitle: 'کدینگ درآمد ${_company.cnttcoding} رکورد', icon: Icon(Icons.monetization_on), onPressed: (){}),

                                ],
                              ),
                            )  
                          ],
                        )
                        : CompanyRow(companyBloc: companyBloc, user: user, company: snapshot.data.rows[index], dashboardicon: snapshot.data.rows.length>1,),
                    );
                 },
                );
              return Center(child: CupertinoActivityIndicator(),);
            }
          ),
        ),
      ],
    );
  }
}

class EditCompany extends StatelessWidget {
  const EditCompany({Key key, @required this.user, @required this.company, @required this.companybloc}) : super(key: key);

  final Company company;
  final User user;
  final CompanyBloc companybloc;
  
  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

    FocusNode _fname = FocusNode();
    FocusNode _fsabtsazman = FocusNode();
    FocusNode _fsabt = FocusNode();
    FocusNode _fbdate = FocusNode();
    FocusNode _fedate = FocusNode();
    FocusNode _flastnwid = FocusNode();
    FocusNode _flastnwdate = FocusNode();
    FocusNode _fsabtdate = FocusNode();
    FocusNode _fecoid = FocusNode();
    FocusNode _fbimeid = FocusNode();
    FocusNode _fbimeshobe = FocusNode();
    FocusNode _fnationalid = FocusNode();
    FocusNode _ftax = FocusNode();
    FocusNode _ftaxid = FocusNode();
    FocusNode _femail = FocusNode();
    FocusNode _ftel = FocusNode();
    FocusNode _ffax = FocusNode();
    FocusNode _fpost = FocusNode();
    FocusNode _fnote = FocusNode();
    FocusNode _faddress = FocusNode();
    TextEditingController _edbdate = TextEditingController(text: company.bdate);
    TextEditingController _ededate = TextEditingController(text: company.edate);
    TextEditingController _edsabtdate = TextEditingController(text: company.sabtdate);
    TextEditingController _edlastnwdate = TextEditingController(text: company.lastnwdate);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.7,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FormHeader(
                title: 'سایر اطلاعات پرونده', 
                btnRight: MyIconButton(type: ButtonType.save, onPressed: (){
                  if (_formkey.currentState.validate()){
                    company.sabtdate   = _edsabtdate.text;
                    company.bdate      = _edbdate.text;
                    company.edate      = _ededate.text;
                    company.lastnwdate = _edlastnwdate.text;
                    companybloc.saveCompanyInfo(context, company);
                  }
                }
              )),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Expanded(child: GridTextField(initialValue: company.name, autofocus: true, hint: 'عنوان', notempty: true, onChange: (val){company.name = val;}, focus: _fname, nextfocus: _fsabt,)),
                  Expanded(child: GridTextField(initialValue: company.sabt.toString() ,hint: 'شماره ثبت', notempty: true, onChange: (val){company.sabt = val.isEmpty ? 0 : int.parse(val);}, focus: _fsabt, nextfocus: _fsabtdate,)),
                  Expanded(child: GridTextField(controller: _edsabtdate ,hint: 'تاریخ ثبت', onChange: (val){company.sabtdate = val;}, focus: _fsabtdate, nextfocus: _fsabtsazman, datepicker: true,)),
                  Expanded(child: GridTextField(initialValue: company.sabtsazman.toString() ,hint: 'شماره ثبت سازمان', notempty: true, onChange: (val){company.sabtsazman = val.isEmpty ? 0 : int.parse(val);}, focus: _fsabtsazman, nextfocus: _fbdate,)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: GridTextField(controller: _edbdate ,hint: 'تاریخ شروع فعالیت', notempty: true, onChange: (val){company.bdate = val;}, focus: _fbdate, nextfocus: _fedate, datepicker: true,)),
                  Expanded(child: GridTextField(controller: _ededate ,hint: 'تاریخ انقضاء فعالیت', onChange: (val){company.edate = val;}, focus: _fedate, nextfocus: _flastnwid, datepicker: true,)),
                  Expanded(child: GridTextField(initialValue: company.lastnwid.toString() ,hint: 'شماره آگهی تغییرات', onChange: (val){company.lastnwid = val.isEmpty ? "" : val;}, focus: _flastnwid, nextfocus: _flastnwdate, maxlength: 17,)),
                  Expanded(child: GridTextField(controller: _edlastnwdate ,hint: 'تاریخ آگهی تغییرات', onChange: (val){company.lastnwdate = val;}, focus: _flastnwdate, nextfocus: _fecoid, datepicker: true,)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: GridTextField(initialValue: company.ecoid.toString() ,hint: 'شماره اقتصادی', notempty: true, onChange: (val){company.ecoid = val.isEmpty ? 0 :int.parse(val);}, focus: _fecoid, nextfocus: _fbimeshobe, maxlength: 12,)),
                  Expanded(child: GridTextField(initialValue: company.bimeshobe ,hint: 'شعبه تامین اجتماعی', notempty: true, onChange: (val){company.bimeshobe = val;}, focus: _fbimeshobe, nextfocus: _fbimeid)),
                  Expanded(child: GridTextField(initialValue: company.bimeid.toString() ,hint: 'کد کارگاه', notempty: true, onChange: (val){company.bimeid = val.isEmpty ? 0 :int.parse(val);}, focus: _fbimeid, nextfocus: _fnationalid, maxlength: 12,)),
                  Expanded(child: GridTextField(initialValue: company.nationalid.toString() ,hint: 'شناسه ملی', notempty: true, onChange: (val){company.nationalid = val.isEmpty ? 0 :int.parse(val);}, focus: _fnationalid, nextfocus: _ftax, maxlength: 12,)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: GridTextField(initialValue: company.tax ,hint: 'واحد مالیاتی', onChange: (val){company.tax = val;}, focus: _ftax, nextfocus: _ftaxid,)),
                  Expanded(child: GridTextField(initialValue: company.taxid.toString() ,hint: 'شماره پرونده', notempty: true, onChange: (val){company.taxid = val.isEmpty ? 0 :int.parse(val);}, focus: _ftaxid, nextfocus: _femail,)),
                  Expanded(child: GridTextField(initialValue: company.email ,hint: 'پست الکترونیک', onChange: (val){company.email = val;}, focus: _femail, nextfocus: _fpost,)),
                  Expanded(child: GridTextField(initialValue: company.post ,hint: 'کد پستی', notempty: true, onChange: (val){company.post = val;}, focus: _fpost, nextfocus: _ftel,)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: GridTextField(initialValue: company.tel ,hint: 'تلفن', notempty: true, onChange: (val){company.tel = val;}, focus: _ftel, nextfocus: _ffax,)),
                  Expanded(child: GridTextField(initialValue: company.fax ,hint: 'نمایر', notempty: true, onChange: (val){company.fax = val;}, focus: _ffax, nextfocus: _fnote,)),
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: companybloc.pricestream$,
                      initialData: company.price==0 ? 1 : company.price,
                      builder: (context, data){
                        return MultiChooseItem(hint: 'مشمول نرخ گذاری', val: data.data, items: [{'id': 1, 'title': 'الف'},{'id': 2, 'title': 'ب'},{'id': 3, 'title': 'ج'}], onChange: (val){
                          companybloc.setprice(val);
                        },);
                      }
                    )
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: GridTextField(initialValue: company.note ,hint: 'توضیحات', onChange: (val){company.note = val;}, focus: _fnote, nextfocus: _faddress,)),
                  Expanded(child: GridTextField(initialValue: company.address ,hint: 'آدرس', notempty: true, onChange: (val){company.address = val;}, focus: _faddress, nextfocus: _fname,)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FmCompanyUsers extends StatelessWidget {
  const FmCompanyUsers({Key key, @required this.company, @required this.user, @required this.companybloc}) : super(key: key);

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
            FormHeader(title: 'فهرست کاربران ${company.name}', btnRight: MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: FmPeople(nationalid: "", justcheck: true,), done: (dynamic data){
                if (data is People){
                  if (companybloc.companyUsers$.where((element) => element.peopid == data.id).length > 0)
                    myAlert(context: context, title: "توجه", message: "${data.name} ${data.family} قبلا اختصاص داده شده است", color: Colors.lightBlue);
                  showFormAsDialog(context: context, form: UserPassword(companybloc: companybloc, cmpid: this.company.id, userid: 0, peop: data), done: (_){
                    companybloc.loadCompanyUser(context, company.id);
                  });
                }
              })
            )),
            GridCaption(obj: ['کد ملی', 'نام و نام خانوادگی', 'شماره همراه', 'آخرین ورود', 'تغییر کلمه عبور']),
            Expanded(
              child: StreamBuilder(
                stream: companybloc.companyUserStream$,
                builder: (BuildContext congtext, AsyncSnapshot<CompanyUserModel> snapshot){
                  if (snapshot.hasData && snapshot.data.status == Status.error)
                    return ErrorInGrid(snapshot.data.msg);
                  if (snapshot.hasData && snapshot.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snapshot.data.rows.length,
                      itemBuilder: (BuildContext context, int idx){
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: snapshot.data.rows[idx].showgroups
                            ? Column(
                              children: [
                                GroupUserRow(companybloc: companybloc, company: company, user: snapshot.data.rows[idx]),
                                SizedBox(height: 15,),
                                StreamBuilder(
                                  stream: companybloc.companyUserGroupStream$,
                                  builder: (BuildContext congtext, AsyncSnapshot<CompanyUserGroupModel> snapshot){
                                    if (snapshot.hasData && snapshot.data.status == Status.error)
                                      return ErrorInGrid(snapshot.data.msg);
                                    if (snapshot.hasData && snapshot.data.status == Status.loaded)
                                      return Wrap(
                                        children: snapshot.data.rows.map((e) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PermissionChip(selected: e.active, title: e.name, onSelected: (val)=>companybloc.setCompanyUserGroup(context, e))
                                        )).toList(),
                                      );
                                    return Center(child: CupertinoActivityIndicator(),);
                                  }
                                ),
                              ],
                            )
                            : GroupUserRow(companybloc: companybloc, company: company, user: snapshot.data.rows[idx]),
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

class GroupUserRow extends StatelessWidget {
  const GroupUserRow({
    Key key,
    @required this.companybloc,
    @required this.company,
    @required this.user
  }) : super(key: key);

  final CompanyBloc companybloc;
  final Company company;
  final CompanyUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>companybloc.loadCompanyUserGroup(context, company.id, user.id),
      child: Row(
        children: [
          UserPic(id: user.id,),
          Switch(value: user.active, onChanged: (val)=> companybloc.setCompanyUserActive(context, company.id, user)),
          SizedBox(width: 5.0,),
          Expanded(child: Text('${user.nationalid}')),
          Expanded(child: Text('${user.name} ${user.family}')),
          Expanded(child: Text('${user.mobile}')),
          Expanded(child: Text('${user.lastlogin}')),
          Expanded(child: Text('${user.lastpasschange}')),
          PopupMenuButton(
            tooltip: 'تنظیمات',
            itemBuilder: (_) => <PopupMenuItem<int>>[
              myPopupMenuItem(icon: CupertinoIcons.person_badge_minus, title: 'حذف کاربر', value: 1),
              myPopupMenuItem(icon: CupertinoIcons.lock_shield, title: 'مجوزهای کاربر', value: 2),
              myPopupMenuItem(icon: CupertinoIcons.checkmark_shield, title: 'تغییر رمز عبور', value: 3),
              myPopupMenuItem(icon: CupertinoIcons.person_crop_square, title: 'اطلاعات فردی', value: 4),
            ],
            onSelected: (int menu){
              if (menu == 1)
                companybloc.deleteCompanyUser(context, company.id, user.id);
              else if (menu == 2)
                companybloc.loadCompanyUserGroup(context, company.id, user.id);
              else if (menu == 3)
                showFormAsDialog(context: context, form: UserPassword(companybloc: companybloc, cmpid: company.id, userid: user.id,));
              else if (menu == 4){
                showFormAsDialog(context: context, form: FmPeople(justcheck: false, nationalid: user.nationalid,), done: (_){
                  companybloc.loadCompanyUser(context, company.id);
                });
              }
            }
          )
        ],
      ),
    );
  }
}

class UserPassword extends StatelessWidget {
  const UserPassword({Key key, @required this.companybloc, @required this.cmpid, this.userid=0, this.peop}) : super(key: key);

  final CompanyBloc companybloc;
  final People peop;
  final int cmpid;
  final int userid;

  @override
  Widget build(BuildContext context) {
    Map<String, String> _data = {'pass': '', 'pass2': ''};
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              child: Card(
                color: appbarColor(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('${peop != null ? 'اختصاص کاربر' : 'تغییر کلمه عبور' }', style: headerStyle(), textAlign: TextAlign.center,),
                ),
              ),
            ),
            peop != null 
              ? Card(child: MyRow(children: ['کد ملی', '${peop.nationalid}']))
              : Container(),
            peop != null
              ? Card(child: MyRow(children: ['نام و نام خانوادگی', '${peop.name} ${peop.family}']))
              : Container(),
            peop != null
              ? Card(child: MyRow(children: ['شماره همراه (نام کاربری)', '${peop.mobile}']))
              : Container(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: GridTextField(hint: 'رمز عبور', width: 150.0, passfield: true, onChange: (val) => _data['pass']=val,)),
                        Expanded(child: GridTextField(hint: 'تکرار رمز عبور', width: 150.0, passfield: true, onChange: (val) => _data['pass2']=val)),
                      ],
                    ),
                    SizedBox(height: 25.0,),
                    Row(
                      children: [
                        Expanded(child: MyOutlineButton(color: Colors.green, icon: Icons.vpn_key, title: 'ادامه عملیات', onPressed: ()=> this.companybloc.setCompanyUserPass(context, cmpid, userid, peop==null ? 0 : peop.id, _data['pass'], _data['pass2']))),
                        Expanded(child: MyOutlineButton(icon: Icons.undo, title: 'انصراف', onPressed: ()=>Navigator.pop(context))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class CompanybyLaw extends StatelessWidget {
  const CompanybyLaw({Key key, @required this.companyBloc, @required this.cmp}) : super(key: key);

  final CompanyBloc companyBloc;
  final Company cmp;

  @override
  Widget build(BuildContext context) {
    TextEditingController _date1 = TextEditingController(text: cmp.andate1);
    TextEditingController _date2 = TextEditingController(text: cmp.andate2);
    TextEditingController _date3 = TextEditingController(text: cmp.andate3);
    TextEditingController _date4 = TextEditingController(text: cmp.andate4);
    RasteBloc _raste = RasteBloc()..loadData(context);

    final _formkey = GlobalKey<FormState>();
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.75,
        height: screenWidth(context) * 0.85,
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              FormHeader(
                title: 'آیین نامه اتحادیه ${cmp.name}', 
                btnRight: MyIconButton(
                  type: ButtonType.save, 
                  onPressed: (){
                    if (_formkey.currentState.validate()){
                      cmp.andate1 = _date1.text;
                      cmp.andate2 = _date2.text;
                      cmp.andate3 = _date3.text;
                      cmp.andate4 = _date4.text;
                      companyBloc.saveCompanybylaw(context, cmp);
                    }
                  }
                )
              ),
              SizedBox(height: 10,),
              Card(
                child: Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'تاریخ ارسال به اتاق', datepicker: true, controller: _date1, notempty: true, autofocus: true)),
                    Expanded(child: GridTextField(hint: 'تاریخ تصویب کمیسیون', datepicker: true, controller: _date2, notempty: true)),
                    Expanded(child: GridTextField(hint: 'تاریخ تصویب اجلاس', datepicker: true, controller: _date3, notempty: true)),
                    Expanded(child: GridTextField(hint: 'تاریخ تصویب کمیسیون نظارت', datepicker: true, controller: _date4, notempty: true)),
                  ],
                ),
              ),
              GridTextField(hint: 'ماده ۱ - تعریف اتحادیه', initialValue: cmp.made1, onChange: (val) => cmp.made1=val, notempty: true),
              GridTextField(hint: 'ماده ۲ - تعریف فرد صنفی', initialValue: cmp.made2, onChange: (val) => cmp.made2=val, notempty: true),
              GridCaption(obj: [SizedBox(width: 65), 'کد آیسیک','', 'عنوان','']),
              Container(
                height: 300,
                child: StreamBuilder(
                  stream: _raste.rasteblocStream$,
                  builder: (BuildContext context, AsyncSnapshot<RasteModel> snap){
                    if (snap.hasData)
                      if (snap.data.status == Status.error)
                        return ErrorInGrid(snap.data.msg);
                      else if (snap.data.status == Status.loaded)
                        return ListView.builder(
                          itemCount: snap.data.rows.length,
                          itemBuilder: (context, idx){
                            Raste _rs = snap.data.rows[idx];
                            if (_rs.cmpid == cmp.id)
                              return MyRow(
                                children: [
                                  Switch(value: _rs.active, onChanged: (_){}),
                                  SizedBox(width: 25),
                                  _rs.isic,
                                  _rs.name
                                ],
                                padding: false,
                              );
                            else
                              return Container();
                          }
                        );
                    return Center(child: CupertinoActivityIndicator());
                  },
                ),
              ),
              SizedBox(height: 10,),
              GridTextField(hint: 'ماده ۴ - حداقل مساحت', initialValue: cmp.made4, onChange: (val) => cmp.made4=val, notempty: true),
              GridTextField(hint: 'ماده ۵ - نوع کالا و خدمات', initialValue: cmp.made5, onChange: (val) => cmp.made5=val, notempty: true),
              GridTextField(hint: 'ماده ۶ - لوازم و اسباب کار', initialValue: cmp.made6, onChange: (val) => cmp.made6=val, notempty: true),
              GridTextField(hint: 'ماده ۷ - تجهیزات ایمنی - انتظامی و تاسیسات بهداشتی', initialValue: cmp.made7, onChange: (val) => cmp.made7=val, notempty: true),
            ],
          ),
        ),
      )
    );
  }
}









