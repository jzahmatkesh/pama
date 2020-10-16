import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../People/People.dart';
import 'CompanyBloc.dart';

class FmEmployee extends StatelessWidget {
  const FmEmployee({Key key, @required this.company, @required this.user, @required this.companybloc}) : super(key: key);

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
            FormHeader(title: 'کارمندان و مشاوران ${company.name}', btnRight: MyIconButton(type: ButtonType.add, onPressed: () => showFormAsDialog(context: context, form: FmPeople(nationalid: "", justcheck: true,), done: (dynamic data){
                if (data is People){
                  if (companybloc.companyEmployee$.where((element) => element.peopid == data.id).length > 0)
                    myAlert(context: context, title: "توجه", message: "${data.name} ${data.family} قبلا اختصاص داده شده است");
                  else
                    showFormAsDialog(
                      context: context, 
                      form: EmployeeEdit(
                        companybloc: this.companybloc, 
                        cmpid: this.company.id, 
                        employee:new Employee(
                          peopid: data.id,
                          name: data.name,
                          family: data.family,
                          nationalid: data.nationalid,
                          mobile: data.mobile,
                          hdate: "",
                          cntbdate: "",
                          cntedate: "",
                          cnttype: 1,
                          expyear: 0,
                          kind: 1,
                          permit: 0,
                          semat: 1,
                          note: "",
                          showfamily: false
                        ),
                      )
                    );
                }
              }
            ))),
            GridCaption(obj: ['کد ملی', 'نام و نام خانوادگی', 'سمت', 'نوع قرارداد', 'نوع همکاری', 'تاریخ شروع قرارداد', 'تاریخ اتمام قرارداد']),
            Expanded(
              child: StreamBuilder(
                stream: companybloc.employeeStream$,
                builder: (BuildContext congtext, AsyncSnapshot<EmployeeModel> snapshot){
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
                                  Card(color: accentcolor(context).withOpacity(0.5),child: EmployeeRow(cmpid: this.company.id, companybloc: this.companybloc,emp: snapshot.data.rows[idx])),
                                  SizedBox(height: 15.0,),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: EmployeeFamily(cmpid: this.company.id, companybloc: this.companybloc,emp: snapshot.data.rows[idx], color: idx.isOdd ? scaffoldcolor(context) : appbarColor(context),),
                                    ),
                                  )
                                ],
                              ),
                            ) 
                            : EmployeeRow(cmpid: this.company.id, companybloc: this.companybloc,emp: snapshot.data.rows[idx]),
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

class EmployeeRow extends StatelessWidget {
  const EmployeeRow({Key key, @required this.companybloc,@required this.cmpid, @required this.emp}) : super(key: key);

  final Employee emp;
  final int cmpid;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => showFormAsDialog(context: context, form: EmployeeEdit(companybloc: companybloc, cmpid: cmpid, employee: emp)),
      child: Row(
        children: [
          PeoplePic(id: emp.peopid,),
          SizedBox(width: 5.0,),
          Expanded(child: Text('${emp.nationalid}')),
          Expanded(child: Text('${emp.name} ${emp.family}')),
          Expanded(child: Text('${emp.sematName()}')),
          Expanded(child: Text('${emp.cntTypeName()}')),
          Expanded(child: Text('${emp.kindName()}')),
          Expanded(child: Text('${emp.cntbdate}')),
          Expanded(child: Text('${emp.cntedate}')),
          PopupMenuButton(
            tooltip: 'تنظیمات',
            itemBuilder: (_) => <PopupMenuItem<int>>[
              myPopupMenuItem(icon: Icons.delete, title: 'حذف کارمند', value: 1),
              myPopupMenuItem(icon: Icons.people, title: 'اعضای خانواده', value: 2),
              myPopupMenuItem(icon: Icons.people, title: 'اطلاعات تکمیلی', value: 3),
              myPopupMenuItem(icon: Icons.attach_file, title: 'بارگذاری فایل', value: 4),
            ],
            onSelected: (int menu){
              if (menu == 1)
                companybloc.deleteEmployee(context, cmpid, emp);
              if (menu == 2)
                companybloc.showEmployeeFamily(context, cmpid, emp.peopid);
            }
          )
        ],
      ),
    );
  }
}

class EmployeeFamily extends StatelessWidget {

  const EmployeeFamily({Key key, @required this.companybloc,@required this.cmpid, @required this.emp, @required this.color}) : super(key: key);

  final Employee emp;
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
                if (companybloc.companyEmpFamily$.where((element) => element.peopid == data.id).length > 0)
                  myAlert(context: context, title: "توجه", message: "${data.name} ${data.family} قبلا اختصاص داده شده است");
                else
                  showFormAsDialog(
                    context: context, 
                    form: EmployeeFamilyEdit(
                      companybloc: this.companybloc, 
                      cmpid: this.cmpid, 
                      emp: this.emp,
                      family:new EmpFamily(
                        peopid: data.id,
                        name: data.name,
                        family: data.family,
                        nationalid: data.nationalid,
                        mobile: data.mobile,
                        note: "",
                        education: 1,
                        isargari: 0,
                        job: "",
                        kind: 1,
                        mdate: "",
                        reshte: ""
                      ),
                    )
                  );
              }
            })),
            'کد ملی','نام و نام خانوادگی', 'نسبت', 'میزان تحصیلات', 'رشته تحصیلی', 'تاریخ ازدواج', 'ایثارگری', 
            MyIconButton(type: ButtonType.exit, onPressed: ()=>companybloc.showEmployeeFamily(context, cmpid, emp.peopid)),
          ], endbuttons: 0,
        ),
        Expanded(
          child: StreamBuilder(
            stream: companybloc.empfamilyStream$,
            builder: (BuildContext congtext, AsyncSnapshot<EmpFamilyModel> snapshot){
              if (snapshot.hasData && snapshot.data.status == Status.error)
                return ErrorInGrid(snapshot.data.msg);
              if (snapshot.hasData && snapshot.data.status == Status.loaded)
                return ListView.builder(
                  itemCount: snapshot.data.rows.length,
                  itemBuilder: (BuildContext context, int idx){
                    return Card(
                      color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                      child: GestureDetector(
                        onDoubleTap: ()=>showFormAsDialog(context: context, form: EmployeeFamilyEdit(companybloc: companybloc, cmpid: cmpid, emp: emp, family: snapshot.data.rows[idx])),
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
                            MyIconButton(type: ButtonType.del, onPressed: ()=>companybloc.deleteEmpFamily(context, cmpid, emp.peopid, snapshot.data.rows[idx]))
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

class EmployeeEdit extends StatelessWidget {
  const EmployeeEdit({Key key, @required this.companybloc, @required this.cmpid, @required this.employee}) : super(key: key);

  final int cmpid;
  final Employee employee;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {

    TextEditingController _hdate = TextEditingController(text: employee.hdate);
    TextEditingController _cntbdate = TextEditingController(text: employee.cntbdate);
    TextEditingController _cntedate = TextEditingController(text: employee.cntedate);
    companybloc.editEmployee(employee);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: companybloc.newemployeeStream$,
        builder: (BuildContext context, AsyncSnapshot<Employee> snap){
          if (!snap.hasData)
            return Center(child: CupertinoActivityIndicator(),);
          Employee emp = snap.data;
          return Container(
            width: screenWidth(context) * 0.4,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(title: 'ویرایش اطلاعات کارمندان و مشاوران', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){
                  emp.hdate = _hdate.text;
                  emp.cntbdate = _cntbdate.text;
                  emp.cntedate = _cntedate.text;
                  companybloc.saveEmployee(context, cmpid, emp);
                })),
                MyRow(
                  children: [
                    'کد ملی',
                    emp.nationalid,
                    MyIconButton(type: ButtonType.info, hint: 'اطلاعات فردی', onPressed: () => showFormAsDialog(context: context, form: FmPeople(justcheck: false, nationalid: emp.nationalid,))),
                  ],
                ),
                MyRow(children: ['نام و نام خانوادگی', '${emp.name} ${emp.family}']),
                MyRow(children: ['شماره همراه', emp.mobile]),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(child: GridTextField(hint: 'تاریخ استخدام', controller: _hdate, datepicker: true, autofocus: true, notempty: true)),
                    Expanded(child: GridTextField(hint: 'تاریخ شروع قرارداد', controller: _cntbdate, datepicker: true, notempty: true)),
                    Expanded(child: GridTextField(hint: 'تاریخ پایان قرارداد', controller: _cntedate, datepicker: true,)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MultiChooseItem(
                        hint: 'سمت',
                        val: emp.semat, 
                        items: [
                          {'id': 1, 'title': 'مشاور'},
                          {'id': 2, 'title': 'مدیر اجرایی'},
                          {'id': 3, 'title': 'بازرس'},
                          {'id': 4, 'title': 'حسابدار'},
                          {'id': 5, 'title': 'کمک حسابدار'},
                          {'id': 6, 'title': 'کارپرداز'},
                          {'id': 7, 'title': 'خدماتی'},
                          {'id': 8, 'title': 'کاردان اداری'},
                          {'id': 9, 'title': 'کارشناس اداری'},
                          {'id': 10, 'title': 'منشی'},
                          {'id': 11, 'title': 'غیره'},
                        ],
                        onChange: (val){companybloc.setEmployeeSamat(val);},
                      )
                    ),
                    Expanded(
                      child: MultiChooseItem(
                        hint: 'نوع قرارداد',
                        val: emp.cnttype, 
                        items: [
                          {'id': 1, 'title': 'شفاهی مدت دار'},
                          {'id': 2, 'title': 'شفاهی دائم'},
                          {'id': 3, 'title': 'کتبی موقت'},
                          {'id': 4, 'title': 'کتبی دائم'},
                          {'id': 5, 'title': 'سایر'},
                        ],
                        onChange: (val){companybloc.setEmployeeCntType(val);},
                      )
                    ),
                    Expanded(
                      child: MultiChooseItem(
                        hint: 'نوع همکاری',
                        val: emp.kind, 
                        items: [
                          {'id': 1, 'title': 'تمام وقت'},
                          {'id': 2, 'title': 'نیمه وقت'},
                        ],
                        onChange: (val){companybloc.setEmployeeKind(val);},
                      )
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: GridTextField(hint: 'مدت سابقه قبلی (سال)', initialValue: emp.expyear.toString(), notempty: true, onChange: (val){emp.expyear = int.parse(val);})),
                    Expanded(child: GridTextField(hint: 'شماره مجوز', initialValue: emp.permit.toString(), onChange: (val){emp.permit = int.parse(val);})),
                  ],
                ),
                GridTextField(hint: 'توضیحات', initialValue: emp.note, onChange: (val){emp.note = val;})
              ],
            ),
          );
        }
      ),
    );
  }
}

class EmployeeFamilyEdit extends StatelessWidget {
  const EmployeeFamilyEdit({Key key, @required this.companybloc, @required this.cmpid, @required this.emp, @required this.family}) : super(key: key);

  final int cmpid;
  final Employee emp;
  final EmpFamily family;
  final CompanyBloc companybloc;

  @override
  Widget build(BuildContext context) {

    TextEditingController _mdate = TextEditingController(text: family.mdate);
    companybloc.editEmpFamily(family);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: companybloc.newempFamilyStream$,
        builder: (BuildContext context, AsyncSnapshot<EmpFamily> snap){
          if (!snap.hasData)
            return Center(child: CupertinoActivityIndicator(),);
          EmpFamily family = snap.data;
          return Container(
            width: screenWidth(context) * 0.4,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormHeader(title: 'تعریف/ویرایش اعضای خانواده همکار محترم ${family.name} ${family.family}', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){family.mdate = _mdate.text; companybloc.saveEmpFamily(context, cmpid, emp, family);})),
                MyRow(
                  children: [
                    'کد ملی', 
                    family.nationalid,
                    MyIconButton(type: ButtonType.info, hint: 'اطلاعات فردی', onPressed: () => showFormAsDialog(context: context, form: FmPeople(justcheck: false, nationalid: family.nationalid,))),
                  ]
                ),
                MyRow(children: ['نام و نام خانوادگی', '${family.name} ${family.family}']),
                MyRow(children: ['شماره همراه', family.mobile]),
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
                        onChange: (val) => companybloc.setEmpFamilyKind(val),
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
//440





