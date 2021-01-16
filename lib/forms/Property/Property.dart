import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/forms/Attach/Attach.dart';
import 'package:provider/provider.dart';

import '../../classes/classes.dart';
import '../../module/Widgets.dart';
import '../../module/consts.dart';
import '../../module/functions.dart';
import '../../module/theme-Manager.dart';
import '../AddInfo/AddInfoData.dart';
import 'PropertyBloc.dart';

class FmProperty extends StatelessWidget {
  const FmProperty({Key key, @required this.cmp}) : super(key: key);

  final Company cmp;

  @override
  Widget build(BuildContext context) {
    PropertyBloc _propBloc = PropertyBloc()..loadMobile(context, cmp.id);

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.8,
        child: StreamBuilder<int>(
          stream: _propBloc.menuStream$,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Column(
                children: [
                  FormHeader(title: 'لیست اموال منقول و غیرمنقول ${cmp.name}'),
                  Row(
                    children: [
                      Expanded(child: Card(child: ListTile(leading: Icon(Icons.phone_android), title: Text('تلفن همراه'), selected: snapshot.data==1, onTap: () => _propBloc.loadMobile(context, cmp.id)))),
                      Expanded(child: Card(child: ListTile(leading: Icon(Icons.car_repair), title: Text('خودرو'), selected: snapshot.data==2, onTap: () => _propBloc.loadCar(context, cmp.id)))),
                      Expanded(child: Card(child: ListTile(leading: Icon(Icons.house_siding), title: Text('غیرمنقول'), selected: snapshot.data==3, onTap: () => _propBloc.loadPropGHM(context, cmp.id)))),
                      Expanded(child: Card(child: ListTile(leading: Icon(Icons.monetization_on), title: Text('حساب بانکی'), selected: snapshot.data==4, onTap: () => _propBloc.loadBankHesab(context, cmp.id)))),
                    ],
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: snapshot.data==1 
                      ? PnMobile(bloc: _propBloc, cmpid: cmp.id) 
                      : snapshot.data==2
                        ? PnCar(bloc: _propBloc, cmpid: cmp.id)
                        : snapshot.data==3
                          ? PnPropGHM(bloc: _propBloc, cmpid: cmp.id)
                          : snapshot.data==4
                            ? PnBankHesab(bloc: _propBloc, cmpid: cmp.id)
                            : ErrorInGrid('منوی مورد نظر را انتخاب نمایید', info: true)
                  )
                ],
              );
            return Center(child: CupertinoActivityIndicator());
          }
        ),
      )
    );
  }
}

class PnMobile extends StatelessWidget {
  const PnMobile({Key key, @required this.bloc, @required this.cmpid}) : super(key: key);

  final int cmpid;
  final PropertyBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: (){
                  context.read<ThemeManager>().setCompany(cmpid);
                  showFormAsDialog(context: context, form: NewMobile(bloc: bloc, prop: Property(cmpid: this.cmpid, id: 0, active: 1, peopid: 0)));
                }
              )
              ,'شماره خط', 'تاریخ خرید', 'نام مالک', 'تحویل گیرنده'
            ], 
            endbuttons: 2
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.propertyStream$,
              builder: (BuildContext context, AsyncSnapshot<PropertyModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: GestureDetector(
                            onDoubleTap: (){
                              context.read<ThemeManager>().setCompany(cmpid);
                              showFormAsDialog(context: context, form: NewMobile(bloc: bloc, prop: snap.data.rows[idx]));
                            },
                            child: Row(
                              children: [
                                Tooltip(message: 'فعال/غیرفعال', child: Switch(value: snap.data.rows[idx].active==1, onChanged: (_)=> bloc.setActive(context, snap.data.rows[idx].id))),
                                SizedBox(width: 10.0),
                                Expanded(child: Text('${snap.data.rows[idx].name}')),
                                Expanded(child: Text('${snap.data.rows[idx].buydate}')),
                                Expanded(child: Text('${snap.data.rows[idx].owner}')),
                                Expanded(child: Text('${snap.data.rows[idx].peopfamily}')),
                                MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: ()=>showFormAsDialog(context: context, form: FmAddInfoData(url: 'Property/AddInfo', title: 'اطلاعات تکمیلی ${snap.data.rows[idx].name}', header: {'propid': snap.data.rows[idx].id.toString()}))),
                                MyIconButton(type: ButtonType.attach, onPressed: () => showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${snap.data.rows[idx].name}', tag: 'PropertyMng', id1: snap.data.rows[idx].id))),
                                MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delMobile(context, snap.data.rows[idx]))
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  return Center(child: CupertinoActivityIndicator());
              }
            ),
          ),
        ],
      )
    );
  }
}

class PnCar extends StatelessWidget {
  const PnCar({Key key, @required this.bloc, @required this.cmpid}) : super(key: key);

  final PropertyBloc bloc;
  final int cmpid;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: (){
                  context.read<ThemeManager>().setCompany(cmpid);
                  showFormAsDialog(context: context, form: NewCar(bloc: bloc, prop: Property(cmpid: this.cmpid, id: 0, peopid: 0)));
                }
              ),
              'نوع خودرو', 'تاریخ خرید', 'رنگ', 'وضعیت', 'شماره پلاک', 'تحویل گیرنده'
            ], 
            endbuttons: 2
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.propertyStream$,
              builder: (BuildContext context, AsyncSnapshot<PropertyModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: GestureDetector(
                            onDoubleTap: (){
                              context.read<ThemeManager>().setCompany(cmpid);
                              showFormAsDialog(context: context, form: NewCar(bloc: bloc, prop: snap.data.rows[idx]));
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 85.0),
                                Expanded(child: Text('${snap.data.rows[idx].name}')),
                                Expanded(child: Text('${snap.data.rows[idx].buydate}')),
                                Expanded(child: Text('${snap.data.rows[idx].color}')),
                                Expanded(child: Text('${snap.data.rows[idx].status}')),
                                Expanded(child: Text('${snap.data.rows[idx].pelak}')),
                                Expanded(child: Text('${snap.data.rows[idx].peopfamily}')),
                                MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: ()=>showFormAsDialog(context: context, form: FmAddInfoData(url: 'Property/AddInfo', title: 'اطلاعات تکمیلی ${snap.data.rows[idx].name}', header: {'propid': snap.data.rows[idx].id.toString()}))),
                                MyIconButton(type: ButtonType.attach, onPressed: () => showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${snap.data.rows[idx].name}', tag: 'PropertyMng', id1: snap.data.rows[idx].id))),
                                MyIconButton(type: ButtonType.del, onPressed: () => bloc.delCar(context, snap.data.rows[idx]))
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  return Center(child: CupertinoActivityIndicator());
              }
            ),
          )
        ]
      ),
    );
  }
}

class PnPropGHM extends StatelessWidget {
  const PnPropGHM({Key key, @required this.bloc, @required this.cmpid}) : super(key: key);

  final PropertyBloc bloc;
  final int cmpid;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: ()=>showFormAsDialog(context: context, form: NewPropGHM(bloc: bloc, prop: Property(cmpid: cmpid, id: 0, malekiat: 1, tenant: 1, price: 0, metraj: 0, cprice: 0, age: 0)))
              ),
              'عنوان', 'نوع مالکیت', 'متراژ', 'سن بنا', 'پلاک ثبتی', 'بهره بردار'
            ], 
            endbuttons: 2
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.propertyStream$,
              builder: (BuildContext context, AsyncSnapshot<PropertyModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: GestureDetector(
                            onDoubleTap: ()=>showFormAsDialog(context: context, form: NewPropGHM(bloc: bloc, prop: snap.data.rows[idx])),
                            child: Row(
                              children: [
                                SizedBox(width: 85),
                                Expanded(child: Text('${snap.data.rows[idx].name}')),
                                Expanded(child: Text('${snap.data.rows[idx].malekiatName()}')),
                                Expanded(child: Text('${snap.data.rows[idx].metraj}')),
                                Expanded(child: Text('${snap.data.rows[idx].age}')),
                                Expanded(child: Text('${snap.data.rows[idx].pelak}')),
                                Expanded(child: Text('${snap.data.rows[idx].tenantName()}')),
                                MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: ()=>showFormAsDialog(context: context, form: FmAddInfoData(url: 'Property/AddInfo', title: 'اطلاعات تکمیلی ${snap.data.rows[idx].name}', header: {'propid': snap.data.rows[idx].id.toString()}))),
                                MyIconButton(type: ButtonType.attach, onPressed: () => showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${snap.data.rows[idx].name}', tag: 'PropertyMng', id1: snap.data.rows[idx].id))),
                                MyIconButton(type: ButtonType.del, onPressed: ()=>bloc.delPropGHM(context, snap.data.rows[idx]))
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  return Center(child: CupertinoActivityIndicator());
              }
            ),
          ),
        ],
      )
    );
  }
}

class PnBankHesab extends StatelessWidget {
  const PnBankHesab({Key key, @required this.bloc, @required this.cmpid}) : super(key: key);

  final PropertyBloc bloc;
  final int cmpid;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          GridCaption(
            obj: [
              MyIconButton(
                type: ButtonType.add, 
                onPressed: () => showFormAsDialog(context: context, form: NewBankHesab(bloc: bloc, prop: Property(cmpid: cmpid, id: 0, accounttype: 1, tafsiliid: 0, internetbank: 0, owner: '')))
              ),
              'بانک', 'نوع حساب', 'صاحب حساب', 'شماره حساب', 'تاریخ افتتاح'
            ], 
            endbuttons: 2
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.propertyStream$,
              builder: (BuildContext context, AsyncSnapshot<PropertyModel> snap){
                if (snap.hasData)
                  if (snap.data.status == Status.error)
                    return ErrorInGrid(snap.data.msg);
                  else if (snap.data.status == Status.loaded)
                    return ListView.builder(
                      itemCount: snap.data.rows.length,
                      itemBuilder: (context, idx){
                        return Card(
                          color: idx.isOdd ? appbarColor(context) : Colors.transparent,
                          child: GestureDetector(
                            onDoubleTap: ()=> showFormAsDialog(context: context, form: NewBankHesab(bloc: bloc, prop: snap.data.rows[idx])),
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Expanded(child: Text('${snap.data.rows[idx].bankName}')),
                                SizedBox(width: 50),
                                Expanded(child: Text('${snap.data.rows[idx].accountTypeName()}')),
                                Expanded(child: Text('${snap.data.rows[idx].owner}')),
                                Expanded(child: Text('${snap.data.rows[idx].hesabno}')),
                                Expanded(child: Text('${snap.data.rows[idx].buydate}')),
                                Tooltip(message: 'اینترنت بانک', child: Switch(value: snap.data.rows[idx].internetbank==1, onChanged: (val)=>bloc.setInternetBank(context, snap.data.rows[idx].id))),
                                MyIconButton(type: ButtonType.other, icon: Icon(CupertinoIcons.list_bullet), hint: 'اطلاعات تکمیلی', onPressed: ()=>showFormAsDialog(context: context, form: FmAddInfoData(url: 'Property/AddInfo', title: 'اطلاعات تکمیلی ${snap.data.rows[idx].name}', header: {'propid': snap.data.rows[idx].id.toString()}))),
                                MyIconButton(type: ButtonType.attach, onPressed: () => showFormAsDialog(context: context, form: FmAttach(title: 'فایلهای ضمیمه ${snap.data.rows[idx].name}', tag: 'PropertyMng', id1: snap.data.rows[idx].id))),
                                MyIconButton(type: ButtonType.del, onPressed: ()=> bloc.delBankHesab(context, snap.data.rows[idx]))
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  return Center(child: CupertinoActivityIndicator());
              }
            ),
          ),
        ],
      )
    );
  }
}

class NewMobile extends StatelessWidget {
  const NewMobile({Key key, @required this.bloc, @required this.prop}) : super(key: key);

  final Property prop;
  final PropertyBloc bloc;

  @override
  Widget build(BuildContext context){
    final _formkey = GlobalKey<FormState>();

    TextEditingController _date = TextEditingController(text: prop.buydate);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'تعریف/ویرایش اطلاعات تلفن همراه', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){prop.buydate = _date.text; if (_formkey.currentState.validate()) bloc.saveMobile(context, prop);})),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'شماره خط',  initialValue: prop.name, autofocus: true, onChange: (val)=>prop.name = val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'تاریخ خرید', controller: _date, datepicker: true, notempty: true)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'نام مالک',  initialValue: prop.owner, autofocus: true, onChange: (val)=>prop.owner = val, notempty: true)),
                  Expanded(child: ForeignKeyField(hint: 'تحویل گیرنده', initialValue: {'id': prop.peopid, 'name': prop.peopfamily}, f2key: 'Employee', onChange: (val){if (val!=null){prop.peopid = val['id']; prop.peopfamily = val['name'];}})),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

class NewCar extends StatelessWidget {
  const NewCar({Key key, @required this.bloc, @required this.prop}) : super(key: key);

  final Property prop;
  final PropertyBloc bloc;

  @override
  Widget build(BuildContext context){
    final _formkey = GlobalKey<FormState>();
    TextEditingController _date = TextEditingController(text: prop.buydate);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'تعریف/ویرایش اطلاعات خودرو', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){prop.buydate = _date.text; if (_formkey.currentState.validate()) bloc.saveCar(context, prop);})),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'نوع خودرو',  initialValue: prop.name, autofocus: true, onChange: (val)=>prop.name = val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'تاریخ خرید', controller: _date, datepicker: true, notempty: true)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'رنگ',  initialValue: prop.color, autofocus: true, onChange: (val)=>prop.color = val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'وضعیت',  initialValue: prop.status, autofocus: true, onChange: (val)=>prop.status = val, notempty: true)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'شماره پلاک',  initialValue: prop.pelak, autofocus: true, onChange: (val)=>prop.pelak = val, notempty: true)),
                  Expanded(child: ForeignKeyField(hint: 'تحویل گیرنده', initialValue: {'id': prop.peopid, 'name': prop.peopfamily}, f2key: 'Employee', onChange: (val){if (val!=null){prop.peopid = val['id']; prop.peopfamily = val['name'];}})),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

class NewPropGHM extends StatelessWidget {
  const NewPropGHM({Key key, @required this.bloc, @required this.prop}) : super(key: key);

  final Property prop;
  final PropertyBloc bloc;

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    TextEditingController _date = TextEditingController(text: prop.buydate);
    TextEditingController _cntdate = TextEditingController(text: prop.contractdate);
    bloc.setMultItem(prop.malekiat, malekiat: true);
    bloc.setMultItem(prop.tenant, tenant: true);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'تعریف/ویرایش اطلاعات اموال غیرمنقول', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){prop.malekiat=bloc.malekiaTypeValue$; prop.buydate = _date.text; prop.contractdate = _cntdate.text; if (_formkey.currentState.validate()) bloc.savePropGHM(context, prop);})),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'عنوان',  initialValue: prop.name, autofocus: true, onChange: (val)=>prop.name = val, notempty: true)),
                  Expanded(
                    child: StreamBuilder<Object>(
                      stream: bloc.malekiaTypeStream$,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return MultiChooseItem(
                            hint: 'نوع مالکیت',
                            val: snapshot.data,
                            onChange: (val)=>bloc.setMultItem(val, malekiat: true),
                            items: [{'id': 1, 'title': 'تملیک'},{'id': 2, 'title': 'استیجاری'}],
                          );
                        return Center(child: CupertinoActivityIndicator());
                      }
                    )
                  ),
                  Expanded(child: GridTextField(hint: 'مورد استفاده', initialValue: prop.usage, onChange: (val)=>prop.usage = val)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'تاریخ انعقاد قرارداد',  controller: _cntdate, datepicker: true, notempty: true)),
                  Expanded(child: GridTextField(hint: 'قیمت خرید/اجاره',  initialValue: '${moneySeprator(prop.price)}', onChange: (val)=>prop.price = double.parse(val.replaceAll(",", "")), money: true, notempty: true)),
                  Expanded(child: GridTextField(hint: 'متراژ(مترمربع)',  initialValue: '${prop.metraj}', onChange: (val)=>prop.metraj = int.parse(val), notempty: true)),
                  Expanded(child: GridTextField(hint: 'سن بنا (سال)',  initialValue: '${prop.age}', onChange: (val)=>prop.age = int.parse(val), notempty: true)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'ارزش تقریبی روز',  initialValue: '${moneySeprator(prop.cprice)}', onChange: (val)=>prop.cprice = double.parse(val.replaceAll(",", "")), money: true,)),
                  Expanded(child: GridTextField(hint: 'کاربری',  initialValue: prop.karbari, onChange: (val)=>prop.karbari = val)),
                  Expanded(
                    child: StreamBuilder<Object>(
                      stream: bloc.tenantTypeStream$,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return MultiChooseItem(
                            hint: 'بهره بردار',
                            val: snapshot.data,
                            onChange: (val)=>bloc.setMultItem(val, tenant: true),
                            items: [{'id': 1, 'title': 'اتحادیه'},{'id': 2, 'title': 'اتاق'},{'id': 3, 'title': 'مستاجر'}],
                          );
                        return Center(child: CupertinoActivityIndicator());
                      }
                    )
                  ),
                  Expanded(child: GridTextField(hint: 'پلاک ثبتی',  initialValue: prop.pelak, onChange: (val)=>prop.pelak = val)),
                ],
              ),
              GridTextField(hint: 'نشانی',  initialValue: prop.address, onChange: (val)=>prop.address = val, notempty: true)
            ],
          ),
        ),
      )
    );
  }
}

class NewBankHesab extends StatelessWidget {
  const NewBankHesab({Key key, @required this.bloc, @required this.prop}) : super(key: key);

  final Property prop;
  final PropertyBloc bloc;

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    TextEditingController _date = TextEditingController(text: prop.buydate);
    bloc.setMultItem(prop.accounttype, account: true);
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Container(
        width: screenWidth(context) * 0.5,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'تعریف/ویرایش اطلاعات حسابهای بانک', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){prop.accounttype=bloc.accountTypevalue$; prop.buydate = _date.text; if (_formkey.currentState.validate()) bloc.saveBankHesab(context, prop);})),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<Object>(
                      stream: bloc.accountTypeStream$,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return MultiChooseItem(
                            hint: 'نوع حساب',
                            val: snapshot.data,
                            onChange: (val)=>bloc.setMultItem(val, account: true),
                            items: [{'id': 1, 'title': 'جاری'},{'id': 2, 'title': 'سپرده'},{'id': 3, 'title': 'قرض الحسنه'}],
                          );
                        return Center(child: CupertinoActivityIndicator());
                      }
                    )
                  ),
                  Expanded(child: ForeignKeyField(hint: 'نام بانک', initialValue: {'id': prop.bankid, "name": prop.bankName}, f2key: "Bank", onChange: (val){if (val!=null){prop.bankid=val['id'];prop.bankName=val['name'];}})),
                  Expanded(child: GridTextField(hint: 'تاریخ افتتاح حساب',  controller: _date, datepicker: true, notempty: true)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'صاحب حساب',  initialValue: prop.owner, onChange: (val)=>prop.owner = val)),
                  Expanded(child: GridTextField(hint: 'شرایط برداشت', initialValue: prop.bcondition, onChange: (val)=>prop.bcondition = val)),
                  Expanded(child: GridTextField(hint: 'حساب تفصیلی سانیار', initialValue: '${prop.tafsiliid}', onChange: (val)=>prop.tafsiliid = int.parse(val), notempty: true)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'شماره حساب',  initialValue: prop.hesabno, onChange: (val)=>prop.hesabno = val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'شماره شبا',  initialValue: prop.shaba, onChange: (val)=>prop.shaba = val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'شماره کارت',  initialValue: prop.cardno, onChange: (val)=>prop.cardno = val)),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

