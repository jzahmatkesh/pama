import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pama/classes/classes.dart';
import 'package:pama/forms/NoLicense/NoLicenseBloc.dart';
import 'package:pama/module/Widgets.dart';
import 'package:pama/module/consts.dart';
import 'package:pama/module/functions.dart';

class FmNoLicense extends StatelessWidget {
  const FmNoLicense({Key key, @required this.cmpid}) : super(key: key);

  final int cmpid;

  @override
  Widget build(BuildContext context) {
    NoLicenseBloc _bloc = NoLicenseBloc()..load(context, cmpid);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenWidth(context) * 0.85,
        height: screenHeight(context) * 0.85,
        child: Column(
          children: [
            FormHeader(
              title: 'فهرست فاقدین پروانه شناسایی شده', 
              btnRight: MyIconButton(
                type: ButtonType.add, 
                onPressed: ()=>showFormAsDialog(context: context, form: NewNoLicense(bloc: _bloc, lcn: new Nolicense(cmpid: this.cmpid, id: 0, isic: 0, note: '')))
              )
            ),
            GridCaption(obj: ['کد ملی','نام و نام خانوادگی','کد آیسیک','تلفن','کد پستی','کد نوسازی شهرسازی','نشانی','','توضیحات اجراییات','']),          
            Expanded(
              child: StreamBuilder(
                stream: _bloc.nolicenseStream$,
                builder: (BuildContext context, AsyncSnapshot<NoLicenseModel> snap){
                  if (snap.hasData)
                    if (snap.data.status == Status.error)
                      return ErrorInGrid(snap.data.msg);
                    else if (snap.data.status == Status.loaded)
                      return ListView.builder(
                        itemCount: snap.data.rows.length,
                        itemBuilder: (context, idx){
                          Nolicense _lcn = snap.data.rows[idx];
                          return Card(
                            child: Padding(
                              padding: _lcn.note.isEmpty ? EdgeInsets.symmetric(horizontal: 8) : EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                              child: GestureDetector(
                                onDoubleTap: (){if (_lcn.note.isEmpty) showFormAsDialog(context: context, form: NewNoLicense(bloc: _bloc, lcn: _lcn));},
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${_lcn.nationalid}')),
                                    Expanded(child: Text('${_lcn.name} ${_lcn.family}')),
                                    Expanded(child: Text('${_lcn.isic}')),
                                    Expanded(child: Text('${_lcn.tel}')),
                                    Expanded(child: Text('${_lcn.post}')),
                                    Expanded(child: Text('${_lcn.nosazicode}')),
                                    Expanded(flex: 2, child: Text('${_lcn.address}')),
                                    Expanded(flex: 2, child: Text('${_lcn.note}')),
                                    _lcn.note.isEmpty ? MyIconButton(type: ButtonType.del, onPressed: () => _bloc.delete(context, _lcn)) : Container()
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      );
                  return Center(child: CupertinoActivityIndicator());
                },  
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewNoLicense extends StatelessWidget {
  const NewNoLicense({Key key, @required this.bloc, @required this.lcn}) : super(key: key);

  final NoLicenseBloc bloc;
  final Nolicense lcn;

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    return Container(
      width: screenWidth(context) * 0.65,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormHeader(title: 'تعریف/ویرایش اطلاعات فاقدین پروانه', btnRight: MyIconButton(type: ButtonType.save, onPressed: (){if (_formkey.currentState.validate()) bloc.save(context, lcn);})),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'کد ملی', initialValue: lcn.nationalid, onChange: (val)=>lcn.nationalid=val, autofocus: true, notempty: true)),
                  Expanded(child: GridTextField(hint: 'نام', initialValue: lcn.name, onChange: (val)=>lcn.name=val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'نام خانوادگی', initialValue: lcn.family, onChange: (val)=>lcn.family=val, notempty: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: GridTextField(hint: 'کد آیسیک', initialValue: lcn.isic.toString(), onChange: (val)=>lcn.isic=int.parse(val), notempty: true)),
                  Expanded(child: GridTextField(hint: 'تلفن', initialValue: lcn.tel, onChange: (val)=>lcn.tel=val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'کد پستی', initialValue: lcn.post, onChange: (val)=>lcn.post=val, notempty: true)),
                  Expanded(child: GridTextField(hint: 'کد نوسازی شهرداری', initialValue: lcn.nosazicode, onChange: (val)=>lcn.nosazicode=val)),
                ],
              ),
              GridTextField(hint: 'نشانی', initialValue: lcn.address, onChange: (val)=>lcn.address=val, notempty: true)
            ],
          ),
        ),
      )
    );
  }
}



