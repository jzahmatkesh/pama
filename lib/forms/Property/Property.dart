import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/forms/Property/PropertyBloc.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';
import 'package:pama/module/theme-Manager.dart';
import 'package:provider/provider.dart';

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
                                SizedBox(width: 10.0),
                                Expanded(child: Text('${snap.data.rows[idx].name}')),
                                Expanded(child: Text('${snap.data.rows[idx].buydate}')),
                                Expanded(child: Text('${snap.data.rows[idx].color}')),
                                Expanded(child: Text('${snap.data.rows[idx].status}')),
                                Expanded(child: Text('${snap.data.rows[idx].pelak}')),
                                Expanded(child: Text('${snap.data.rows[idx].peopfamily}')),
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
          GridCaption(obj: [MyIconButton(type: ButtonType.add, onPressed: (){},),'عنوان', 'نوع مالکیت', 'متراژ', 'سن بنا', 'پلاک ثبتی', 'بهره بردار'], endbuttons: 2),
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
                          child: Row(
                            children: [
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              MyIconButton(type: ButtonType.del, onPressed: (){})
                            ],
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
          GridCaption(obj: [MyIconButton(type: ButtonType.add, onPressed: (){},),'عنوان', 'نوع حساب', 'صاحب حساب', 'شماره حساب', 'تاریخ افتتاح'], endbuttons: 2),
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
                          child: Row(
                            children: [
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              Expanded(child: Text('')),
                              Switch(value: true, onChanged: (_){}),
                              Expanded(child: Text('')),
                              MyIconButton(type: ButtonType.del, onPressed: (){})
                            ],
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
                  Expanded(child: ForeignKeyField(hint: 'تحویل گیرنده', initialValue: {'id': prop.peopid, 'name': prop.peopfamily}, f2key: 'Employee', onChange: (val){prop.peopid = val['id']; prop.peopfamily = val['name'];})),
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
                  Expanded(child: ForeignKeyField(hint: 'تحویل گیرنده', initialValue: {'id': prop.peopid, 'name': prop.peopfamily}, f2key: 'Employee', onChange: (val){prop.peopid = val['id']; prop.peopfamily = val['name'];})),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}




